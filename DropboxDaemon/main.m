//
// main.m
// dropboxd, MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <sys/types.h>
#import <sys/stat.h>
#import <stdio.h>
#import <stdlib.h>
#import <fcntl.h>
#import <errno.h>
#import <unistd.h>
#import <syslog.h>
#import <string.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import "DropboxSDK.h"
#import "DropboxDaemonDelegate.h"

int main (int argc, char **argv) {

	setuid (0);

	pid_t pid = fork ();
	if (pid < 0) {
		exit (EXIT_FAILURE);
	}
	if (pid > 0) {
		FILE *f = fopen ("/var/root/myfile/dropboxd.pid", "w");
		fprintf (f, "%i", pid);
		fclose (f);
		exit (EXIT_SUCCESS);
	}

	umask (0);
		
	pid_t sid = setsid ();
	if (sid < 0) {
		exit (EXIT_FAILURE);
	}
	
	if ((chdir ("/")) < 0) {
		exit (EXIT_FAILURE);
	}
	
	close (STDIN_FILENO);
	close (STDOUT_FILENO);
	close (STDERR_FILENO);
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	DropboxDaemonDelegate *daemonDelegate = [[DropboxDaemonDelegate alloc] init];
	NSDate *now = [[NSDate alloc] init];
	NSTimer *timer = [[NSTimer alloc] initWithFireDate: now interval: 15.0 target: daemonDelegate selector: @selector(check) userInfo: nil repeats: YES];
	[now release];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer: timer forMode: NSDefaultRunLoopMode];
	[runLoop run];
	[timer release];
	[pool release];

	return 0;

}
