//
//  main.m
//  mkcli
//
//  Created by John Heaton on 4/13/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDIKit.h"
#import "LPMessage.h"
#import <readline/readline.h>
#import <AppKit/AppKit.h>
#import <objc/runtime.h>

extern int rl_completion_append_character; // new readline
extern int _rl_bell_preference;
extern "C" void rl_replace_line(const char *, int);

JSValue *runTestScript(MKJavaScriptContext *c, NSString *name) {
    return [c require:name];
}

char **completions(const char *frag, int i) {
    rl_completion_append_character = 0;

    NSString *c;
    NSMutableArray *classMatches = [NSMutableArray array];
    for(Class cc in@[
                        [MIDIKit class],
                        [MKConnection class],
                        [MKMessage class],
                        [MKObject class],
                        [MKDevice class],
                        [MKClient class],
                        [MKInputPort class],
                        [MKOutputPort class],
                        [MKDestination class],
                        [MKSource class],
                        [MKEntity class],
                        [MKVirtualDestination class],
                        [MKVirtualSource class],
                        [MKServer class]
                        ]) {
        if([(c = NSStringFromClass(cc)) rangeOfString:@(frag)].location != NSNotFound) {
            [classMatches addObject:c];
        }
    }

    if(classMatches.count) {
        if(classMatches.count == 1) {
            rl_completion_append_character = '.';

            return !i ? (char **)strdup([classMatches.firstObject UTF8String]) : NULL;
        } else {
            int ind=0;
            for(NSString *match in classMatches) {
                printf("%s%s\n", !ind ? "\n" : "", match.UTF8String);
                ++ind;
            }
            rl_on_new_line();

            return NULL;
        }
    }

    return NULL;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
#define COREMIDI_QUEUE dispatch_get_main_queue()

        MKJavaScriptContext *c = [MKJavaScriptContext new];
        c[@"LPMessage"] = [LPMessage class];

#define START "\033["
#define COLOR START "38;5;"
#define ORANGE COLOR "197m"
#define LESLIEKNOPE COLOR "161m"
#define SEXY COLOR "61m"
#define PINK COLOR "135m"
#define BOOBY COLOR "208m"
#define DOLPHIN COLOR "89m"
#define FLOOP COLOR "35m"
#define DOOP COLOR "37m"
#define ZOOP COLOR "70m"
#define CROOP COLOR "72m"
#define RESET START "0m"

        [MIDIKit setOSStatusEvaluationLogsOnError:YES];

        __weak typeof(c) _c = c;
        __block NSUInteger currentLine = 0;
        c.exceptionHandler = ^(JSContext *context, JSValue *exception) {

            printf("%s",
                   [NSString stringWithFormat:@"%s-> %s%@%@%s\n",
                    ORANGE,
                    LESLIEKNOPE,
                    !currentLine ? @"" : [NSString stringWithFormat:@"Line %lu: ", (unsigned long)currentLine],
                    [NSString stringWithFormat:@"Line %d: %@", [(exception.toObject)[@"line"] intValue], exception],
                    RESET
                    ].UTF8String);
        };

        NSString *execPath = [NSBundle mainBundle].executablePath;
        execPath = [execPath substringToIndex:execPath.length - execPath.lastPathComponent.length];

        if(argc > 2) {
            NSLog(@"using argv[1]...");

            c.currentEvaluatingScriptPath = @(argv[1]);
        } else {
            _c[@"__dirname"] = [NSFileManager defaultManager].currentDirectoryPath;
        }

        c[@"clear"] = ^{ printf("\x1b""c"); };
        c[@"setPath"] = ^(NSString *path) { _c[@"__dirname"] = path; };
        c[@"help"] = ^{ printf("%s\n",
                               "\n"
                               ZOOP
                               "Built-In (midirepl):\n    "
                               CROOP
                               "require(path)           -- " FLOOP "evaluate a script\n    " CROOP
                               "showEval(bool)          -- " FLOOP "set whether return values should be printed\n    " CROOP
                               "setCwd(path)            -- " FLOOP "sets the path for require() calls to CWD\n    " CROOP
                               "MIDIRestart()           -- " FLOOP "for when you kill the server with bad code\n    " CROOP
                               "process                 -- " FLOOP "global process object\n    " CROOP
                               "help()                  -- " FLOOP "show this\n\n" CROOP

                               ZOOP
                               "MIDIKit Classes:\n    "
                               CROOP
                               "MIDIKit                 -- " FLOOP "For global settings\n    " CROOP
                               "MKObject                -- " FLOOP "Base wrapper\n    " CROOP
                               "MKClient                -- " FLOOP "Client to the MIDI server\n    " CROOP
                               "MKInputPort             -- " FLOOP "Port for receiving data\n    " CROOP
                               "MKOutputPort            -- " FLOOP "Port for sending data\n    " CROOP
                               "MKDevice                -- " FLOOP "Root hardware object\n    " CROOP
                               "MKEntity                -- " FLOOP "Child of MKDevice, owns endpoints\n    " CROOP
                               "MKSource                -- " FLOOP "Input entity\n    " CROOP
                               "MKDestination           -- " FLOOP "Output entity\n    " CROOP
                               "MKVirtualSource         -- " FLOOP "Client-created endpoint for sending data to MIDI programs\n    " CROOP
                               "MKVirtualDestination    -- " FLOOP "Client-created endpoint for receiving data from MIDI programs\n    " CROOP
                               "MKMessage               -- " FLOOP "Model representing a command to be sent via MIDI\n    " CROOP
                               "MKConnection            -- " FLOOP "Convenience class for easier multi-endpoint operations\n\n    " CROOP

                               PINK
                               "Use MIDIKit.openGitHub() to check out the latest info.\n"
                               RESET
                               );
        };

        c[@"require"] = ^JSValue *(NSString *path) {
            NSString *evalPath = [_c[@"__dirname"] toString];
            if([path hasPrefix:@"./"] || ![path hasPrefix:@"/"])
                path = [evalPath stringByAppendingPathComponent:path];

            if(![path hasSuffix:@".js"] && [path.lastPathComponent componentsSeparatedByString:@"."].count == 1) {
                path = [path stringByAppendingString:@".js"];
            }

            if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [_c evaluateScript:[NSString stringWithFormat:@"throw new Error('Script does not exist: %@')", path]];
                return [JSValue valueWithUndefinedInContext:_c];
            }

            NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            return [_c evaluateScript:[NSString stringWithFormat:
                                           @"(function() {                      "
                                           "    var module = { exports: {} };   "
                                           "    exports = module.exports;       "
                                           "    (function () {                  "
                                           "        %@                          "
                                           "    })();                           "
                                           "    return module.exports;          "
                                           "})()                                ",
                                           s]];
        };
        c[@"setCwd"] = ^JSValue *{ _c[@"__dirname"] = [_c evaluateScript:@"process.cwd()"]; return _c[@"__dirname"]; };

        __block BOOL showEval = YES;
        c[@"showEval"] = ^(BOOL show) { showEval = show; };


        /////////////////////--------------------------------------------------------------------

        if(![NSProcessInfo processInfo].environment[@"REPL"]) {
            printf("to run in REPL mode, set env var REPL=1\n");
            // standard exec

            CFRunLoopRun();

            return 0;
        }

        rl_initialize();
        using_history();
        _rl_bell_preference = 0;

        rl_completion_entry_function = (Function *)completions;
#define hist [@"~/.midirepl_history" stringByExpandingTildeInPath].UTF8String

        read_history(hist);
        signal(SIGINT, [](int c) {
            puts(" (use ^D to exit)");
            rl_replace_line("", 0);
            rl_on_new_line();
            rl_redisplay();
        });
        c[@"quit"] = c[@"process"][@"exit"];

        printf(ZOOP "midirepl v0 by John Heaton\n" SEXY "help() is available\n" SEXY "quit() or ^D to get out\n" RESET);

        [[NSOperationQueue new] addOperationWithBlock:^{
            while(1) {
                const char *buf;
                buf = readline("\001" DOOP "\002~> \001" RESET "\002");

                if(!buf) exit(0);
                add_history(buf);
                write_history(hist);

                dispatch_sync(COREMIDI_QUEUE, ^{
                    JSValue *val;
                    @try {
                        if(!strcmp(buf, "clear()")) {
                            [c[@"clear"] callWithArguments:nil];
                            return;
                        }
                        val = [c evaluateScript:@(buf)];

                        if(showEval) {
                            const char *print = NULL;

                            BOOL isBadVal = (val.isUndefined || val.isNull);
                            if(isBadVal) {
                                print = val.isUndefined ? PINK "[undefined]" : PINK "[null]";
                            } else {
                                id objVal = val.toObject;
                                if([objVal isKindOfClass:[NSDictionary class]] && ![(NSDictionary *)objVal count]) {
                                    print = [val description].UTF8String;
                                } else {
                                    print = [objVal description].UTF8String;
                                }
                            }
                            printf(ORANGE "-> " SEXY "%s\n" RESET, print);
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"ObjC exception thrown: %@", exception);
                    }
                });
            }
        }];

        CFRunLoopRun();
    }
    return 0;
}