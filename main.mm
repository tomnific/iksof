/*
 * Copyright (c) 2019 Tom. All Rights Reserved.
 *
 * @TOM_LICENSE_SOURCE_START@
 *
 * 1) Credit would be sick, but I really can't control what you do ¯\_(ツ)_/¯
 * 2) I'm not responsible for what you do with this AND I'm not responsible for any damage you cause ("THIS SOFTWARE IS PROVIDED AS IS", etc)
 * 3) I'm under no obligation to provide support. (But if you reach out I'll gladly take a look if I have time)
 *
 * @TOM_LICENSE_SOURCE_END@
 */
/*
 * Extracts all symbols from a kernelcache and puts them into a header file.
 * Originally based on Vortex Offset Finder by Uroboro, but has been (will be) extended far beyond it.
 * Unlike the original, the correct IPSW must be manually downloaded. This is intentional.
 * Could this have been done more easily as a shell script? Yes. 
 * Can be built with Xcode or Xpwnd.
 */

#import <Foundation/Foundation.h>
#import <stdtom/stdtom.hh>

#include <iostream>
#include <fstream>

#include <setjmp.h>


#import "symbol_functions.h"




jmp_buf helper_escape;




// SUPER helpful - instead of having an if statement for every system command that returns 'NO' on failure
//                       we simply jump back up to main upon failure
BOOL runsystem(const char* cmd, NSString* error, jmp_buf destination)
{
	if (system(cmd) != 0)
	{
		TMLog(@"%@", error);
		
		longjmp(destination, NO);
	}
	
	
	return YES;
}




NSString *symbolToDefineMacro(symbol_t symbol)
{
	return [NSString stringWithFormat:@"#define %@_OFFSET 0x%llx", [symbol.name uppercaseString], symbol.offset];
}




void writeSymbolsToHeaderFile(NSArray *symbols)
{
	ofstream header_file;
	header_file.open("./iksof_offsets.h");
	
	
	header_file << "#ifndef iksof_offsets_h" << "\n" << "#define iksof_offsets_h" << "\n\n\n";
	
	
	TMLog(@"Writing offsets to header file...");
	
	for (NSValue* object in symbols)
	{
		header_file << [symbolToDefineMacro(object.symbolValue) UTF8String] << "\n";
	}
	
	TMLog(@"Done.");
	
	
	header_file << "\n" << "#endif" << "\n";
	
	
	header_file.close();
}




NSArray *getSymbolOffsets(NSString *kernelcachePath)
{
	NSMutableArray *symbols;
	
	
	symbols = [[NSMutableArray alloc] init];
	
	
	TMLog(@"Getting offsets, please wait...");
	[symbols addObject:getOffset_kernel_map(kernelcachePath)];
	[symbols addObject:getOffset_kernel_task(kernelcachePath)];
	[symbols addObject:getOffset_bzero(kernelcachePath)];
	[symbols addObject:getOffset_bcopy(kernelcachePath)];
	[symbols addObject:getOffset_copyin(kernelcachePath)];
	[symbols addObject:getOffset_copyout(kernelcachePath)];
	[symbols addObject:getOffset_rootvnode(kernelcachePath)];
	[symbols addObject:getOffset_kauth_cred_ref(kernelcachePath)];
	[symbols addObject:getOffset_ZNK12OSSerializer9serializeEP11OSSerialize(kernelcachePath)];
	[symbols addObject:getOffset_address_host_priv_self(kernelcachePath)];
	[symbols addObject:getOffset_ipc_port_alloc_special(kernelcachePath)];
	[symbols addObject:getOffset_ipc_kobject_set(kernelcachePath)];
	[symbols addObject:getOffset_ipc_port_make_send(kernelcachePath)];
	[symbols addObject:getOffset_rop_add_x0_x0_0x10(kernelcachePath)];
	[symbols addObject:getOffset_zone_map(kernelcachePath)];
	[symbols addObject:getOffset_iosurfacerootuserclient_vtab(kernelcachePath, @"./com.apple.iokit.IOSurface.kext")];
	TMLog(@"Done.");
	
	
	return (NSArray *) [symbols copy];
}




void printKernelVersion(const char* kernelcache_path)
{
	TMLog(@"Kernel version: ");
	
	
	const char* print_kernel_version = [[NSString stringWithFormat:@"strings %s | grep 'Darwin K'\n echo", kernelcache_path] UTF8String];
	
	if (system(print_kernel_version) != 0)
	{
		printf("[ ERROR ]");
	}
}




BOOL extractKext(NSString *kextName)
{
	// just to make printing look nicer
	NSArray *reverseDNSIDs = [kextName componentsSeparatedByString:@"."];
	NSString *normalName = reverseDNSIDs[reverseDNSIDs.count - 2];
	
	
	TMLog(@"Extracting %@ kext...", normalName);
	

	// should consider making a 'systemf(char* cmd_format, ...)' function
	if (system([[NSString stringWithFormat:@"/opt/iksof/bin/joker -K %@ kernelcache &> /dev/null", kextName] UTF8String]) != 0)
	{
		TMLog(@"   ERROR: Could not extract %@ kext.", normalName);
		
		
		return NO;
	}
	
	
	if (system([[NSString stringWithFormat:@"mv /tmp/%@ ./", kextName] UTF8String]) != 0)
	{
		TMLog(@"   ERROR: Could not retrieve %@ kext.", normalName);
		
		
		return NO;
	}
	
	
	TMLog(@"Done.");
	
	
	return YES;
}




BOOL decompressKernelcache()
{
	TMLog(@"Decompressing Kernelcache...");
	
	
	if (system("/opt/iksof/bin/joker -dec kernelcache.comp &> /dev/null") != 0)
	{
		TMLog(@"   ERROR: Could not decompress kernelcache.");
		
		
		return NO;
	}
	
	
	if (system("mv /tmp/kernel ./kernelcache") != 0)
	{
		TMLog(@"   ERROR: Could not retrieve kernelcache from /tmp/.");
	}

	
	TMLog(@"Done.");
	
	
	return true;
}




BOOL extractKernelcache(NSString *ipswPath)
{
	TMLog(@"Extracting Kernelcache...");
	
	
	// Could be done more directly with popen() - but since we're using Objective-C it's actually a lot easier to make a string from a file's contents rather than read from a FILE to a buffer
	const char* get_kernelcache_filename = [[NSString stringWithFormat:@"unzip -l %@ | grep -m 1 kernelcache | awk '{ print $NF }' > kernelcache-name.txt", ipswPath] UTF8String];
	
	if (system(get_kernelcache_filename) != 0)
	{
		TMLog(@"   ERROR: Failed to get kernelcache filename.");
		
		
		return NO;
	}
	
	
	NSString* kernelcacheName = [[NSString stringWithContentsOfFile:@"kernelcache-name.txt" encoding:NSUTF8StringEncoding error:NULL] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	[[NSFileManager defaultManager] removeItemAtPath:@"./kernelcache-name.txt" error:NULL];
	
	TMLog(@"    UPDATE: Found kernelcahce name: %@", kernelcacheName);
	
	
	// unzip -p $file $kernel_name > kernelcache.comp
	const char* extract_kernelcache = [[NSString stringWithFormat:@"unzip -p %@ %@ > kernelcache.comp", ipswPath, kernelcacheName] UTF8String];

	if(system(extract_kernelcache) != 0)
	{
		TMLog(@"   ERROR: Failed to extract kernelcache.");


		return NO;
	}
	
	
	TMLog(@"Done.");
	
	
	return true;
}




// Since we now check against setjmp, it's kinda pointless for this function to return anything. Oh well.
BOOL checkAndInstallHelpers()
{
	if (access("/opt/iksof/bin", F_OK) != 0)
	{
		TMLog(@"Creating helpers directory...");
		runsystem("mkdir -p /opt/iksof/bin &> /dev/null", @"ERROR: Could not make helpers directory", helper_escape);
		TMLog(@"Done.");
	}
	
	
	if (system("brew ls --versions radare2 &> /dev/null") != 0)
	{
		TMLog(@"Installing radare2...");
		runsystem("brew install radare2 &> /dev/null", @"ERROR: Could not install radare2. Try updating Homebrew.", helper_escape);
		TMLog(@"Done.");
	}
	
	
	if (access("/opt/iksof/bin/partialzip", F_OK) != 0)
	{
		TMLog(@"Installing partialzip...");
		
		if (access("./partial-zip", F_OK) == 0)
		{
			TMLog(@"   Prepping...");
			runsystem("rm -rf ./partial-zip &> /dev/null", @"   ERROR: Could not delete previous partial-zip.", helper_escape);
			TMLog(@"   Done.");
		}
		
		TMLog(@"   Downloading...");
		runsystem("git clone https://github.com/uroboro/partial-zip &> /dev/null", @"   ERROR: Failed to download partial-zip.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Building...");
//		runsystem("pushd partial-zip", @"   ERROR: Could not switch to partial-zip directory."); // no idea why this doesn't work - tried every possible variation
		chdir("./partial-zip");
		runsystem("cmake . &> /dev/null", @"   ERROR: Could not cmake partial-zip.", helper_escape);
		runsystem("make &> /dev/null", @"   ERROR: Could not build partial-zip.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Moving partial-zip to helpers directory.");
//		runsystem("cd - &> /dev/null", @"   ERROR: Could not return to previous directory."); // no idea man
		chdir("..");
		runsystem("cp partial-zip/partialzip /opt/iksof/bin/", @"   ERROR: Could not copy partialzip to helpers directory", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Cleaning up...");
		runsystem("rm -rf partial-zip", @"ERROR: Could not delete local partial-zip.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"Done.");
	}
	
	
	if (access("/opt/iksof/bin/joker", F_OK) != 0)
	{
		TMLog(@"Installing joker...");
		
		TMLog(@"   Downloading...");
		runsystem("curl -s http://newosxbook.com/tools/joker.tar -o joker.tar &> /dev/null", @"ERROR: Could not download joker.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Extracting...");
		runsystem("tar -xf joker.tar joker.universal &> /dev/null", @"ERROR: Could not extract joker executable.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Moving to helpers directory...");
		runsystem("mv joker.universal /opt/iksof/bin/joker &> /dev/null", @"ERROR: Could not move joker to helpers directory.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"   Cleaning up...");
		runsystem("rm joker.tar &> /dev/null", @"ERROR: Could not delete local joker tarball.", helper_escape);
		TMLog(@"   Done.");
		
		TMLog(@"Done.");
	}
	
	
	return YES;
}




int main(int argc, char * argv[])
{
	@autoreleasepool
	{
		setLogPrefix(@"[iksof] ");


		TMLog(@"Welcome to the iOS Kernel Symbol Offset Finder!");
		
		
		if (argc == 3)
		{
			if (argIsPresent(argc, argv, @"--ipsw"))
			{
				NSString *ipswPath = getArg(argc, argv, @"--ipsw");

				if (access([ipswPath UTF8String], F_OK) == 0 && !isdir([ipswPath UTF8String]))
				{
					// it'd be greate if we could get rid of this pyramid of death, but most solutions simply move the problem elsewhere in the file
					if (setjmp(helper_escape) == 0)
					{
						checkAndInstallHelpers();
						
						if (access("./kernelcache", F_OK) != 0) // maybe we should make these local to the ipsw path?? eh, we'll decide come release time
						{
							// no need to re-extract kernel if one already exists in the same directory as the ipsw
							if (access("kernelcache.comp", F_OK) != 0)
							{
								if(!extractKernelcache(ipswPath)) // since it's short, doing jumps here would be overkill
								{
									TMLog(@"ERROR: Failed to extract the kernelcache.");
									
									
									return -1;
								}
							}
							else
							{
								TMLog(@"Kernelcache from a previous session found.");
							}
							
							if (!decompressKernelcache())
							{
								TMLog(@"ERROR: Failed to decompress kernelcache.");
								
								
								return -1;
							}
						}
						else
						{
							TMLog(@"Decompressed kernelcache from previous session found.");
						}
						
						if (access("com.apple.iokit.IOSurface.kext", F_OK) != 0)
						{
							if (!extractKext(@"com.apple.iokit.IOSurface.kext"))
							{
								TMLog(@"ERROR: Failed to extract IOSurface kext.");
								
								
								return -1;
							}
						}
						else
						{
							TMLog(@"Extracted IOSurface kext from previous session found.");
						}
						
						printKernelVersion("./kernelcache"); //sure, we could just hardcode it into the function itself.
						
						NSArray *symbols = getSymbolOffsets(@"./kernelcache");
						writeSymbolsToHeaderFile(symbols);
					}
					else
					{
						TMLog(@"ERROR: Could not install helpers.");

						
						return -1;
					}
				}
				else
				{
					TMLog(@"ERROR: Invald path to IPSW ('%@'). Be sure it's not a directory.", ipswPath);


					return -1;
				}
			}
			else
			{
				TMLog(@"ERROR: Invalid arguments");


				return -1;
			}
		}
		else
		{
			TMLog(@"Usage: iksof --ipsw <ipsw-path>");


			return -1;
		}
	}
	
	
	return 0;
}
