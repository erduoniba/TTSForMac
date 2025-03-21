//
// Copyright (c) Microsoft. All rights reserved.
// See https://aka.ms/csspeech/license for the full license information.
//

#import "SPXFoundation.h"
#import "SPXAudioConfiguration.h"
#import "SPXAutoDetectSourceLanguageConfiguration.h"
#import "SPXSourceLanguageConfiguration.h"
#import "SPXSpeechConfiguration.h"
#import "SPXSpeechRecognizer.h"
#import "SPXSpeechRecognitionResult.h"
#import "SPXSpeechRecognitionEventArgs.h"
#import "SPXEmbeddedSpeechConfiguration.h"

/**
 * Performs speech recognition on the specified audio input, and gets transcribed text as result.
 */
SPX_EXPORT
@interface SPXSpeechRecognizer : SPXRecognizer

typedef void (^SPXSpeechRecognitionEventHandler)(SPXSpeechRecognizer * _Nonnull, SPXSpeechRecognitionEventArgs * _Nonnull);
typedef void (^SPXSpeechRecognitionCanceledEventHandler)(SPXSpeechRecognizer * _Nonnull, SPXSpeechRecognitionCanceledEventArgs * _Nonnull);
typedef void (^SPXSpeechRecognitionAsyncCompletionHandler)(void);

/**
 * Authorization token used to communicate with the speech recognition service.
 *
 * Note: The caller needs to ensure that the authorization token is valid. Before the authorization token expires,
 * the caller needs to refresh it by calling this setter with a new valid token.
 * Otherwise, the recognizer will encounter errors during recognition.
 */
@property (nonatomic, copy, nullable)NSString *authorizationToken;

/**
 * Endpoint ID of a customized speech model that is used for speech recognition.
 */
@property (nonatomic, copy, readonly, nullable)NSString *endpointId;

/**
 * Initializes a new instance of speech recognizer.
 *
 * @param speechConfiguration speech recognition configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)init:(nonnull SPXSpeechConfiguration *)speechConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer.
 *
 * Added in version 1.6.0.
 *
 * @param speechConfiguration speech recognition configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)init:(nonnull SPXSpeechConfiguration *)speechConfiguration error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified audio config.
 *
 * @param speechConfiguration speech recognition configuration.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified audio config.
 *
 * Added in version 1.6.0.

 * @param speechConfiguration speech recognition configuration.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified audio config.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified audio config.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified source language.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param language source language.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration language:(nonnull NSString *)language
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified source language.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param language source language.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
                                            language:(nonnull NSString *)language
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified source language and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param language source language.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration 
                                            language:(nonnull NSString *)language
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified source language and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param language source language.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
                                            language:(nonnull NSString *)language
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified source language configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param sourceLanguageConfiguration the source language configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
                         sourceLanguageConfiguration:(nonnull SPXSourceLanguageConfiguration *)sourceLanguageConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified source language configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param sourceLanguageConfiguration the source language configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
                         sourceLanguageConfiguration:(nonnull SPXSourceLanguageConfiguration *)sourceLanguageConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified source language configuration and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param sourceLanguageConfiguration the source language configuration.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
                         sourceLanguageConfiguration:(nonnull SPXSourceLanguageConfiguration *)sourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified source language configuration and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param sourceLanguageConfiguration the source language configuration.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration 
                         sourceLanguageConfiguration:(nonnull SPXSourceLanguageConfiguration *)sourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection and audio configuration.
 *
 * Added in version 1.12.0.

 * @param speechConfiguration speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithSpeechConfiguration:(nonnull SPXSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection and audio configuration.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param audioConfiguration audio configuration.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes a new instance of speech recognizer using the specified configuration for auto language detection and audio configuration.
 *
 * @param speechConfiguration embedded speech recognition configuration.
 * @param autoDetectSourceLanguageConfiguration the configuration for auto language detection.
 * @param audioConfiguration audio configuration.
 * @param outError error information.
 * @return an instance of speech recognizer.
 */
- (nullable instancetype)initWithEmbeddedSpeechConfiguration:(nonnull SPXEmbeddedSpeechConfiguration *)speechConfiguration
               autoDetectSourceLanguageConfiguration:(nonnull SPXAutoDetectSourceLanguageConfiguration *)autoDetectSourceLanguageConfiguration
                                  audioConfiguration:(nonnull SPXAudioConfiguration *)audioConfiguration
                                               error:(NSError * _Nullable * _Nullable)outError;

/**
 * Starts speech recognition, and returns after a single utterance is recognized. The end of a
 * single utterance is determined by listening for silence at the end or until a maximum of about 30
 * seconds of audio is processed. The task returns the recognition text as result.
 *
 * Note: Since recognizeOnceAsync() returns only a single utterance, it is suitable only for single
 * shot recognition like command or query.
 * For long-running multi-utterance recognition, use startContinuousRecognition() instead.
 *
 * @return the result of speech recognition.
 */
- (nonnull SPXSpeechRecognitionResult *)recognizeOnce
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.") NS_RETURNS_RETAINED;

/**
 * Starts speech recognition, and returns after a single utterance is recognized. The end of a
 * single utterance is determined by listening for silence at the end or until a maximum of about 30
 * seconds of audio is processed. The task returns the recognition text as result.
 *
 * Note: Since recognizeOnceAsync() returns only a single utterance, it is suitable only for single
 * shot recognition like command or query.
 * For long-running multi-utterance recognition, use startContinuousRecognition() instead.
 *
 * Added in version 1.6.0.
 *
 * @param outError error information.
 * @return the result of speech recognition.
 */
- (nullable SPXSpeechRecognitionResult *)recognizeOnce:(NSError * _Nullable * _Nullable)outError NS_RETURNS_RETAINED;

/**
 * Starts speech recognition, and returns after a single utterance is recognized. The end of a
 * single utterance is determined by listening for silence at the end or until a maximum of about 30
 * seconds of audio is processed. The task returns the recognition text as result.
 *
 * Note: Since recognizeOnceAsync() returns only a single utterance, it is suitable only for single
 * shot recognition like command or query.
 * For long-running multi-utterance recognition, use startContinuousRecognition() instead.
 *
 * @param resultReceivedHandler the block function to be called when the first utterance has been recognized.
 */
- (void)recognizeOnceAsync:(nonnull void (^)(SPXSpeechRecognitionResult * _Nonnull))resultReceivedHandler
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Starts speech recognition, and returns after a single utterance is recognized. The end of a
 * single utterance is determined by listening for silence at the end or until a maximum of about 30
 * seconds of audio is processed. The task returns the recognition text as result.
 *
 * Note: Since recognizeOnceAsync() returns only a single utterance, it is suitable only for single
 * shot recognition like command or query.
 * For long-running multi-utterance recognition, use startContinuousRecognition() instead.
 *
 * Added in version 1.6.0.
 *
 * @param resultReceivedHandler the block function to be called when the first utterance has been recognized.
 * @param outError error information.
 */
- (BOOL)recognizeOnceAsync:(nonnull void (^)(SPXSpeechRecognitionResult * _Nonnull))resultReceivedHandler error:(NSError * _Nullable * _Nullable)outError;

/**
 * Starts speech recognition on a continuous audio stream, until stopContinuousRecognition() is called.
 * User must subscribe to events to receive recognition results.
 */
- (void)startContinuousRecognition
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Starts speech recognition on a continuous audio stream, until stopContinuousRecognition() is called.
 * User must subscribe to events to receive recognition results.
 *
 * Added in version 1.6.0.
 *
 * @param outError error information.
 */
- (BOOL)startContinuousRecognition:(NSError * _Nullable * _Nullable)outError;

/**
 * Stops continuous speech recognition.
 */
- (void)stopContinuousRecognition
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Stops continuous speech recognition.
 *
 * Added in version 1.6.0.
 *
 * @param outError error information.
 */
- (BOOL)stopContinuousRecognition:(NSError * _Nullable * _Nullable)outError;

/**
 * Begins a speech-to-text interaction with this recognizer using a keyword.
 * This interaction will use the provided keyword model to listen for a keyword indefinitely,
 * during which audio is not sent to the speech service and all processing is performed locally.
 * When a keyword is recognized, SpeechRecognizer will automatically connect to the speech service
 * and begin sending audio data from just before the keyword.
 * When received, speech-to-text results may be processed by the provided result handler
 * or retrieved via a subscription to the recognized event.
 *
 * @param keywordModel the keyword recognition model.
 * @param outError error information.
 * @return a value indicating whether the requested keyword recognition successfully started. If NO, outError may
 * contain additional information.
 */
- (BOOL)startKeywordRecognition
             :(nonnull SPXKeywordRecognitionModel *)keywordModel
        error:(NSError * _Nullable * _Nullable)outError;

/**
 * Begins a speech-to-text interaction with this recognizer using a keyword.
 * This interaction will use the provided keyword model to listen for a keyword indefinitely,
 * during which audio is not sent to the speech service and all processing is performed locally.
 * When a keyword is recognized, SpeechRecognizer will automatically connect to the speech service
 * and begin sending audio data from just before the keyword.
 * When received, speech-to-text results may be processed by the provided result handler
 * or retrieved via a subscription to the recognized event.
 *
 * @param keywordModel the keyword recognition model.
 */
- (void)startKeywordRecognition:(nonnull SPXKeywordRecognitionModel *)keywordModel
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Asynchronously begins a speech-to-text interaction with this recognizer
 * and immediately returns execution to the calling thread.
 * This interaction will use the provided keyword model to listen for a keyword indefinitely,
 * during which audio is not sent to the speech service and all processing is performed locally.
 * When a keyword is recognized, SpeechRecognizer will automatically connect to the speech service
 * and begin sending audio data from just before the keyword.
 * When received, speech-to-text results may be processed by the provided result handler
 * or retrieved via a subscription to the recognized event.
 *
 * @param keywordModel the keyword recognition model.
 * @param completionHandler the handler function called when keyword recognition has started.
 * @param outError error information.
 * @return a value indicating whether the request to start keyword recognition was received successfully. If NO,
 * additional information may available in outError.
 */
- (BOOL)startKeywordRecognitionAsync
                         :(nonnull SPXKeywordRecognitionModel *)keywordModel
        completionHandler:(nonnull SPXSpeechRecognitionAsyncCompletionHandler)completionHandler
                    error:(NSError * _Nullable * _Nullable)outError;

/**
 * Asynchronously begins a speech-to-text interaction with this recognizer
 * and immediately returns execution to the calling thread.
 * This interaction will use the provided keyword model to listen for a keyword indefinitely,
 * during which audio is not sent to the speech service and all processing is performed locally.
 * When a keyword is recognized, SpeechRecognizer will automatically connect to the speech service
 * and begin sending audio data from just before the keyword.
 * When received, speech-to-text results may be processed by the provided result handler
 * or retrieved via a subscription to the recognized event.
 *
 * @param keywordModel the keyword recognition model.
 * @param completionHandler the handler function called when keyword recognition has started.
 */
- (void)startKeywordRecognitionAsync
                         :(nonnull SPXKeywordRecognitionModel *)keywordModel
        completionHandler:(nonnull SPXSpeechRecognitionAsyncCompletionHandler)completionHandler
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Stops any active keyword recognition.
 *
 * @param outError error information.
 * @return a value indicating whether keyword recognition was stopped successfully. If NO, additional information may
 * be available in outError.
 */
- (BOOL)stopKeywordRecognition:(NSError * _Nullable * _Nullable)outError;

/**
 * Stops any active keyword recognition.
 */
- (void)stopKeywordRecognition
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Stops any active keyword recognition.
 *
 * @param completionHandler the handler function called when keyword recognition has stopped.
 * @param outError error information.
 * @return a value indicating whether the request to stop was received successfully. If NO, additional error
 * information may be available in outError.
 */
- (BOOL)stopKeywordRecognitionAsync
             :(nonnull SPXSpeechRecognitionAsyncCompletionHandler)completionHandler
        error:(NSError * _Nullable * _Nullable)outError;

/**
 * Stops any active keyword recognition.
 *
 * @param completionHandler the handler function called when keyword recognition has stopped.
 */
- (void)stopKeywordRecognitionAsync:(nonnull SPXSpeechRecognitionAsyncCompletionHandler)completionHandler
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Subscribes to the Recognized event which indicates that a final result has been recognized.
 */
- (void)addRecognizedEventHandler:(nonnull SPXSpeechRecognitionEventHandler)eventHandler;

/**
 * Subscribes to the Recognizing event which indicates that an intermediate result has been recognized.
 */
- (void)addRecognizingEventHandler:(nonnull SPXSpeechRecognitionEventHandler)eventHandler;

/**
 * Subscribes to the Canceled event which indicates that an error occurred during recognition.
 */
- (void)addCanceledEventHandler:(nonnull SPXSpeechRecognitionCanceledEventHandler)eventHandler;

@end
