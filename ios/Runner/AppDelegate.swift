import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var audioEngine: AVAudioEngine?
    private var silentPlayer: AVAudioPlayer?
    private var methodChannel: FlutterMethodChannel?
    private var isListening = false
    
   // Detection parameters
private var sensitivity: Double = 0.5
private let baseClapThreshold: Float = 0.9      // Higher = ignore soft noise
private let baseWhistleAmplitude: Float = 0.5  // Minimum amplitude to count
private let whistleFreqMin: Float = 1000.0
private let whistleFreqMax: Float = 3000.0

    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        
        // Setup Method Channel
        methodChannel = FlutterMethodChannel(
            name: "com.clapwhistle.alarm/detector",
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            switch call.method {
            case "startBackgroundDetection":
                if let args = call.arguments as? [String: Any],
                   let sensitivity = args["sensitivity"] as? Double {
                    self.sensitivity = sensitivity
                }
                self.startBackgroundDetection()
                result(true)
                
            case "stopBackgroundDetection":
                self.stopBackgroundDetection()
                result(true)
                
            case "updateSensitivity":
                if let args = call.arguments as? [String: Any],
                   let sensitivity = args["sensitivity"] as? Double {
                    self.sensitivity = sensitivity
                }
                result(true)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Background Detection Setup
    
    private func startBackgroundDetection() {
        setupAudioSession()
        startSilentAudio()
        startMicrophoneListening()
        isListening = true
    }
    
    private func stopBackgroundDetection() {
        stopMicrophoneListening()
        stopSilentAudio()
        isListening = false
    }
    
    // MARK: - Audio Session Configuration
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            // Critical: This configuration allows background audio
            try audioSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.mixWithOthers, .allowBluetooth, .defaultToSpeaker]
            )
            
            try audioSession.setActive(true)
            
            print("✅ Audio session configured for background")
        } catch {
            print("❌ Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Silent Audio Player (Keeps session alive)
    
    private func startSilentAudio() {
        // Generate silent audio file
        let silentAudioURL = generateSilentAudio()
        
        do {
            silentPlayer = try AVAudioPlayer(contentsOf: silentAudioURL)
            silentPlayer?.numberOfLoops = -1 // Infinite loop
            silentPlayer?.volume = 0.0 // Silent
            silentPlayer?.play()
            
            print("✅ Silent audio started (keeps session alive)")
        } catch {
            print("❌ Failed to start silent audio: \(error)")
        }
    }
    
    private func stopSilentAudio() {
        silentPlayer?.stop()
        silentPlayer = nil
    }
    
    private func generateSilentAudio() -> URL {
        // Create a silent audio file in temp directory
        let silenceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("silence.m4a")
        
        // If file exists, return it
        if FileManager.default.fileExists(atPath: silenceURL.path) {
            return silenceURL
        }
        
        // Generate 1 second of silent audio
        let sampleRate: Double = 44100.0
        let duration: Double = 1.0
        let frameCount = Int(sampleRate * duration)
        
        let audioFormat = AVAudioFormat(
            standardFormatWithSampleRate: sampleRate,
            channels: 1
        )!
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: audioFormat,
            frameCapacity: AVAudioFrameCount(frameCount)
        ) else {
            fatalError("Could not create audio buffer")
        }
        
        buffer.frameLength = AVAudioFrameCount(frameCount)
        
        // Write silent audio (all zeros)
        do {
            let audioFile = try AVAudioFile(
                forWriting: silenceURL,
                settings: audioFormat.settings
            )
            try audioFile.write(from: buffer)
        } catch {
            print("Error creating silent audio: \(error)")
        }
        
        return silenceURL
    }
    
    // MARK: - Microphone Listening & Detection
    
    private func startMicrophoneListening() {
        audioEngine = AVAudioEngine()
        
        guard let audioEngine = audioEngine else { return }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Install tap on input node
        inputNode.installTap(
            onBus: 0,
            bufferSize: 4096,
            format: recordingFormat
        ) { [weak self] (buffer, time) in
            self?.processAudioBuffer(buffer)
        }
        
        do {
            try audioEngine.start()
            print("✅ Microphone listening started")
        } catch {
            print("❌ Failed to start audio engine: \(error)")
        }
    }
    
    private func stopMicrophoneListening() {
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
    }
    
    // MARK: - Audio Processing & Detection
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        
        let frameLength = Int(buffer.frameLength)
        let samples = Array(UnsafeBufferPointer(start: channelData[0], count: frameLength))
        
        // Calculate amplitude for clap detection
        let maxAmplitude = samples.map { abs($0) }.max() ?? 0.0
        
        // Detect clap
        detectClap(amplitude: maxAmplitude)
        
        // Detect whistle
        detectWhistle(samples: samples, amplitude: maxAmplitude)
    }
    
    private var lastClapTime: Date?
    
   private func detectClap(amplitude: Float) {
    // Adjust threshold based on sensitivity slider
    let adjustedThreshold = baseClapThreshold * Float(1.0 - 0.5 * sensitivity)

    if amplitude > adjustedThreshold {
        let now = Date()
        if let lastClap = lastClapTime, now.timeIntervalSince(lastClap) < 0.5 { return }
        lastClapTime = now

        print("👏 CLAP DETECTED! Amplitude: \(amplitude)")

        DispatchQueue.main.async { [weak self] in
            self?.methodChannel?.invokeMethod("onClapDetected", arguments: nil)
        }
    }
}

    
    private var consecutiveWhistleCount = 0
    private var lastWhistleTime: Date?
    
private func detectWhistle(samples: [Float], amplitude: Float) {
    let adjustedAmplitude = baseWhistleAmplitude * Float(1.0 - 0.5 * sensitivity)
    if amplitude < adjustedAmplitude {
        consecutiveWhistleCount = 0
        return
    }

    let dominantFreq = findDominantFrequency(samples: samples)
    if dominantFreq >= whistleFreqMin && dominantFreq <= whistleFreqMax {
        consecutiveWhistleCount += 1
        if consecutiveWhistleCount >= 3 {
            let now = Date()
            if let lastWhistle = lastWhistleTime, now.timeIntervalSince(lastWhistle) < 1.0 { return }
            lastWhistleTime = now
            consecutiveWhistleCount = 0

            print("🎵 WHISTLE DETECTED! Frequency: \(dominantFreq) Hz")
            DispatchQueue.main.async { [weak self] in
                self?.methodChannel?.invokeMethod("onWhistleDetected", arguments: nil)
            }
        }
    } else {
        consecutiveWhistleCount = 0
    }
}

    
    private func findDominantFrequency(samples: [Float]) -> Float {
        guard samples.count > 1 else { return 0 }
        
        // Zero-crossing rate method for frequency estimation
        var zeroCrossings = 0
        
        for i in 1..<samples.count {
            if (samples[i] >= 0 && samples[i-1] < 0) ||
               (samples[i] < 0 && samples[i-1] >= 0) {
                zeroCrossings += 1
            }
        }
        
        let sampleRate: Float = 44100.0
        let frequency = (Float(zeroCrossings) * sampleRate) / (2.0 * Float(samples.count))
        
        return frequency
    }
}
