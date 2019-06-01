//
//  symbol_functions.m
//  iOS Kernel Symbol Offset Finder
//
//  Created by Tom Metzger on 5/27/19.
//  Copyright © 2019 Tom. All rights reserved.
//

#import "symbol_functions.h"

#import <stdtom/stdtom.hh>




NSValue *getOffsetBySymbolName(NSString *kernelcachePath, NSString *symbolName)
{
	symbol_t symbol;
	
	
	symbol.name = symbolName;
	
	NSString *command = [NSString stringWithFormat:@"nm %@ | grep ' %@' | awk '{ print \"0x\" $1 }'", kernelcachePath, symbolName];
	NSString *offsetString = systemCommand(command);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_kernel_map(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_kernel_map");
}




NSValue *getOffset_kernel_task(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_kernel_task");
}




NSValue *getOffset_bzero(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"___bzero");
}




NSValue *getOffset_bcopy(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_bcopy");
}




NSValue *getOffset_copyin(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_copyin");
}




NSValue *getOffset_copyout(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_copyout");
}




NSValue *getOffset_rootvnode(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_rootvnode");
}




NSValue *getOffset_kauth_cred_ref(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"_kauth_cred_ref");
}




NSValue *getOffset_ZNK12OSSerializer9serializeEP11OSSerialize(NSString *kernelcachePath)
{
	return getOffsetBySymbolName(kernelcachePath, @"__ZNK12OSSerializer9serializeEP11OSSerialize");
}




NSValue *getOffset_address_host_priv_self(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"host_priv_self";
	
	
	NSString *hostPrivSelfAddress = [systemCommand([NSString stringWithFormat:@"nm %@ | grep '%@' | awk '{ print \"0x\" $1 }'", kernelcachePath, @"host_priv_self"]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *hostPrivSelfOffset = systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"pd 2 @ %@\" %@ 2> /dev/null | sed -n 's/0x//gp' | awk '{ print $NF }' | tr '[a-f]\n' '[A-F] ' | awk '{ print \"obase=16;ibase=16;\" $1 \"+\" $2 }' | bc | tr '[A-F]' '[a-f]' | awk '{ print \"0x\" $1 }'", hostPrivSelfAddress, kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:hostPrivSelfOffset];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;

	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_ipc_port_alloc_special(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"ipc_port_alloc_special";
	
	
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -e scr.color=false -q -c 'pd @ sym._convert_task_suspension_token_to_port' %@ 2> /dev/null | sed -n 's/.*bl sym.func.\\([a-z01-9]*\\)/0x\\1/p' | sed -n 1p", kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_ipc_kobject_set(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"ipc_kobject_set";
	
	
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -e scr.color=false -q -c 'pd @ sym._convert_task_suspension_token_to_port' %@ 2> /dev/null | sed -n 's/.*bl sym.func.\\([a-z01-9]*\\)/0x\\1/p' | sed -n 2p", kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_ipc_port_make_send(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"ipc_port_make_send";
	
	
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -e scr.color=false -q -c 'pd @ sym._convert_task_to_port' %@ 2>/dev/null | sed -n 's/.*bl sym.func.\\([a-z01-9]*\\)/0x\\1/p' | sed -n 1p", kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_rop_add_x0_x0_0x10(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"rop_add_x0_x0_0x10";
	
	
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=true -c \"\\\"/a add x0, x0, 0x10; ret\\\"\" %@ 2> /dev/null | head -n1 | awk '{ print $1 }'", kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_rop_ldr_x0_x0_0x10(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"rop_ldr_x0_x0_0x10";
	
	
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=true -c \"\\\"/a ldr x0, [x0, 0x10]; ret\\\"\" %@ 2> /dev/null | head -n1 | awk '{ print $1 }'", kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_zone_map(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"zone_map";
	
	
	NSString *stringAddress = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c 'iz~zone_init: kmem_suballoc failed' %@ 2> /dev/null | awk '{ print $1 }' | sed 's/.*=//'", kernelcachePath]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *xref1Address = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"\\\"/c %@\\\"\" %@ 2> /dev/null | awk '{ print $1 }'", stringAddress, kernelcachePath]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *xref2Address = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"\\\"/c %@\\\"\" %@ 2> /dev/null | awk '{ print $1 }'", xref1Address, kernelcachePath]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"pd -8 @ %@\" %@ 2> /dev/null | head -n 2 | grep 0x | awk '{ print $NF }' | sed 's/0x//' | tr '[a-f]\n' '[A-F] ' | awk '{ print \"obase=16;ibase=16;\" $1 \"+\" $2 }' | bc | tr '[A-F]' '[a-f]'", xref2Address, kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_chgproccnt(NSString *kernelcachePath)
{
	symbol_t symbol;
	
	
	symbol.name = @"chgproccnt";
	
	
	NSString *privCheckCredAddress = [systemCommand([NSString stringWithFormat:@"nm %@ | grep ' _priv_check_cred' | awk '{ print \"0x\" $1 }'", kernelcachePath]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *offsetString = systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"pd 31 @ %@\" %@ 2> /dev/null | tail -n1 | awk '{ print $1 }'", privCheckCredAddress, kernelcachePath]);
	
	unsigned long long offset;
	NSScanner* scanner = [NSScanner scannerWithString:offsetString];
	[scanner scanHexLongLong:&offset];
	symbol.offset = offset;
	
	
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}




NSValue *getOffset_iosurfacerootuserclient_vtab(NSString *kernelcachePath, NSString *IOSurfaceKextPath)
{
	symbol_t symbol;
	
	
	symbol.name = @"iosurfacerootuserclient_vtab";
	
	
	// for some reason we had to echo it, else spaces don't render
	NSString *dataConstConstOffset = [systemCommand([NSString stringWithFormat:@"echo $(r2 -q -e scr.color=false -c 'S' %@ 2> /dev/null | grep '__DATA_CONST.__const' | tr ' ' '\\n' | grep '=')", IOSurfaceKextPath]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *va = [systemCommand([NSString stringWithFormat:@"echo %@ | tr ' ' '\\n' | sed -n 's/va=//p'", dataConstConstOffset]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *sz = [systemCommand([NSString stringWithFormat:@"echo %@ | tr ' ' '\\n' | sed -n 's/^sz=//p'", dataConstConstOffset]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
	systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"s %@; pxr %@\" %@ 2> /dev/null | awk '{ print $1 \" \" $2 }' > /tmp/hexdump.txt", va, sz, IOSurfaceKextPath]);
	
	systemCommand(@"IFS=$'\\n' read -d '' -r -a hexdump < /tmp/hexdump.txt");
	NSString *rawLines = [NSString stringWithContentsOfFile:@"/tmp/hexdump.txt" encoding:NSUTF8StringEncoding error:NULL];//systemCommand(@"wc -l /tmp/hexdump.txt | awk '{ print $1 }'");
	
	
	NSArray *lines = [rawLines componentsSeparatedByString:@"\n"];
	
	
	for (int i = 0; i < [lines count] - 1; i++)
	{
		NSString *firstZero = [systemCommand([NSString stringWithFormat:@"echo %@ | awk '{ print $2 }'", lines[i]]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSString *secondZero = [systemCommand([NSString stringWithFormat:@"echo %@ | awk '{ print $2 }'", lines[i+1]]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		
		if ([firstZero isEqualToString:@"0x0000000000000000"] && [secondZero isEqualToString:@"0x0000000000000000"] && (i+2+7) < [lines count])
		{
			NSString *offsetString = [systemCommand([NSString stringWithFormat:@"echo %@ | awk '{ print $1 }'", lines[i+2]]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSString *pointer8 = [systemCommand([NSString stringWithFormat:@"echo %@ | awk '{ print $2 }'", lines[i+2+7]]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			
			if ([pointer8 length] == 0)
			{
				break;
			}
			
			NSString *commandLookup = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"pd 3 @ %@\" com.apple.iokit.IOSurface.kext 2> /dev/null | awk '{ print $NF }' | tr '\\n' ' ' | awk '{ print $1 \"; \" $2 }'", pointer8]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSString *secondToLast = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=true -c \"\\\"/c %@\\\"\" com.apple.iokit.IOSurface.kext 2>/dev/null | tail -n 2 | head -n 1 | awk '{ print $1 }'", commandLookup]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSString *classAddress = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"pd 3 @ %@\" com.apple.iokit.IOSurface.kext 2> /dev/null | tail -n 2 | awk '{ print $NF }' | tr '\\n' ' ' | awk '{ print $1 \"+\" $2 }'", secondToLast]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSString *name = [systemCommand([NSString stringWithFormat:@"r2 -q -e scr.color=false -c \"ps @ %@\" com.apple.iokit.IOSurface.kext 2> /dev/null | sed 's/[^a-zA-Z]//g'", classAddress]) stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			
			if ([name length] != 0 && [name isEqualToString:@"IOSurfaceRootUserClient"])
			{
				unsigned long long offset;
				NSScanner* scanner = [NSScanner scannerWithString:offsetString];
				[scanner scanHexLongLong:&offset];
				symbol.offset = offset;
				
				NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
				
				
				return symbolObject;
			}
		}
	}
	
	
	symbol.offset = 0xdeadbeefbabeface;
	NSValue *symbolObject = [NSValue valuewithSymbol:symbol];
	
	
	return symbolObject;
}
