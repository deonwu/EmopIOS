//
//  DebuggingTools.h
//  TOP
//
//  Created by Li Zheng Qing on 12-11-23.
//  Copyright (c) 2012年 Tmall.com. All rights reserved.
//
//  直接来自Nimbus的NIDebuggingTools.h
//

#import <Foundation/Foundation.h>

/**
 * For inspecting code and writing to logs in debug builds.
 *
 * Nearly all of the following macros will only do anything if the DEBUG macro is defined.
 * The recommended way to enable the debug tools is to specify DEBUG in the "Preprocessor Macros"
 * field in your application's Debug target settings. Be careful not to set this for your release
 * or app store builds because this will enable code that may cause your app to be rejected.
 *
 *
 * <h2>Debug Assertions</h2>
 *
 * Debug assertions are a lightweight "sanity check". They won't crash the app, nor will they
 * be included in release builds. They <i>will</i> halt the app's execution when debugging so
 * that you can inspect the values that caused the failure.
 *
 * @code
 *  TOPDASSERT(statement);
 * @endcode
 *
 * If <i>statement</i> is false, the statement will be written to the log and if a debugger is
 * attached, the app will break on the assertion line.
 *
 *
 * <h2>Debug Logging</h2>
 *
 * @code
 *  TOPDPRINT(@"formatted log text %d", param1);
 * @endcode
 *
 * Print the given formatted text to the log.
 *
 * @code
 *  TOPDPRINTMETHODNAME();
 * @endcode
 *
 * Print the current method name to the log.
 *
 * @code
 *  TOPDCONDITIONLOG(statement, @"formatted log text %d", param1);
 * @endcode
 *
 * If statement is true, then the formatted text will be written to the log.
 *
 * @code
 *  TOPDINFO/TOPDWARNING/TOPDERROR(@"formatted log text %d", param1);
 * @endcode
 *
 * Will only write the formatted text to the log if TOPMaxLogLevel is greater than the respective
 * TOPD* method's log level. See below for log levels.
 *
 * The default maximum log level is TOPLOGLEVEL_WARNING.
 *
 * <h3>Turning up the log level while the app is running</h3>
 *
 * TOPMaxLogLevel is declared a non-const extern so that you can modify it at runtime. This can
 * be helpful for turning logging on while the application is running.
 *
 * @code
 *  TOPMaxLogLevel = TOPLOGLEVEL_INFO;
 * @endcode
 *
 *      @ingroup NimbusCore
 *      @defgroup Debugging-Tools Debugging Tools
 *      @{
 */

#ifdef DEBUG

/**
 * Assertions that only fire when DEBUG is defined.
 *
 * An assertion is like a programmatic breakpoint. Use it for sanity checks to save headache while
 * writing your code.
 */
#import <TargetConditionals.h>

int TOPIsInDebugger(void);
#if TARGET_IPHONE_SIMULATOR
// We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of
// a "breakInDebugger" function.
#define TOPDASSERT(xx) { if (!(xx)) { TOPDPRINT(@"TOPDASSERT failed: %s", #xx); \
if (TOPDebugAssertionsShouldBreak && TOPIsInDebugger()) { __asm__("int $3\n" : : ); } } \
} ((void)0)
#else
#define TOPDASSERT(xx) { if (!(xx)) { TOPDPRINT(@"TOPDASSERT failed: %s", #xx); \
if (TOPDebugAssertionsShouldBreak && TOPIsInDebugger()) { raise(SIGTRAP); } } \
} ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR

#else
#define TOPDASSERT(xx) ((void)0)
#endif // #ifdef DEBUG


#define TOPLOGLEVEL_INFO     5
#define TOPLOGLEVEL_WARNING  3
#define TOPLOGLEVEL_ERROR    1

/**
 * The maximum log level to output for TOP debug logs.
 *
 * This value may be changed at run-time.
 *
 * The default value is TOPLOGLEVEL_WARNING.
 */
extern NSInteger TOPMaxLogLevel;

/**
 * Whether or not debug assertions should halt program execution like a breakpoint when they fail.
 *
 * An example of when this is used is in unit tests, when failure cases are tested that will
 * fire debug assertions.
 *
 * The default value is YES.
 */
extern BOOL TOPDebugAssertionsShouldBreak;

/**
 * Only writes to the log when DEBUG is defined.
 *
 * This log method will always write to the log, regardless of log levels. It is used by all
 * of the other logging methods in Nimbus' debugging library.
 */
#ifdef DEBUG
#define TOPDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TOPDPRINT(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

/**
 * Write the containing method's name to the log using NIDPRINT.
 */
#define TOPDPRINTMETHODNAME() TOPDPRINT(@"%s", __PRETTY_FUNCTION__)

#ifdef DEBUG
/**
 * Only writes to the log if condition is satisified.
 *
 * This macro powers the level-based loggers. It can also be used for conditionally enabling
 * families of logs.
 */
#define TOPDCONDITIONLOG(condition, xx, ...) { if ((condition)) { TOPDPRINT(xx, ##__VA_ARGS__); } \
} ((void)0)
#else
#define TOPDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG


/**
 * Only writes to the log if TOPMaxLogLevel >= TOPLOGLEVEL_ERROR.
 */
#define TOPDERROR(xx, ...)  TOPDCONDITIONLOG((TOPLOGLEVEL_ERROR <= TOPMaxLogLevel), xx, ##__VA_ARGS__)

/**
 * Only writes to the log if TOPMaxLogLevel >= TOPLOGLEVEL_WARNING.
 */
#define TOPDWARNING(xx, ...)  TOPDCONDITIONLOG((TOPLOGLEVEL_WARNING <= TOPMaxLogLevel), \
xx, ##__VA_ARGS__)

/**
 * Only writes to the log if TOPMaxLogLevel >= TOPLOGLEVEL_INFO.
 */
#define TOPDINFO(xx, ...)  TOPDCONDITIONLOG((TOPLOGLEVEL_INFO <= TOPMaxLogLevel), xx, ##__VA_ARGS__)


///////////////////////////////////////////////////////////////////////////////////////////////////
/**@}*/// End of Debugging Tools //////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
