# iOS Kernel Symbol Offset Finder
Don't ya just hate it when PoC's for iOS exploits are hardcoded to work with one specific device model on one specific subversion of iOS, instead of just dynamically finding the offsets it requires? 

Be annoyed no more - IKSOF finds all<sup><sub>*</sub></sup> those symbol offsets for you and even outputs them in a nice header file as macros.

<br>

## Usage
It's super easy to use:

1. Download the ipsw for the target device and iOS version
2. Run this command:

```bash
iksof --ipsw <path-to-ipsw>
```
* note: unless you configure your shell otherwise, you need the full path to the `iksof` command

## Currently Supported Symbols
<sup><sub>*</sub></sup>all - all of the offsets seen here:

| Name |
|---|
| **`_kernel_map`** |
| **`_kernel_task`** |
| **`_bzero`** |
| **`_bcopy`** |
| **`_copyin`** |
| **`_copyout`** |
| **`_rootvnode`** |
| **`_kauth_cred_ref`** |
| **`_ZNK12OSSerializer9serializeEP11OSSerialize`** |
| **`_address_host_priv_self`** |
| **`ipc_port_alloc_special`** |
| **`_ipc_kobject_set`** |
| **`ipc_port_make_send`** |
| **`_rop_add_x0_x0_0x10`** |
| **`_zone_map`** |
| **`_iosurfacerootuserclient_vtab`** |

That's not a whole lot right now - but since it's enough enable using an (albeit older) exploit that's out there, I'm putting out out into the public as a prerelease. LOTs more will be added soon.

<br>

## Credit
* Originally sourced from [Vortex Offset Finder](https://gist.github.com/uroboro/84309e91c1f92e873c943e94a00f3de1) by Uroboro. I definitely recommend checking it out if you want to learn about extracting symbols
* There are some tools utilized by this program that were not created by and are not owned by me - they are the property of their respective creators

<br>

## Contact
Please report all bugs to the "Issues" page here on GitHub. <br>
If you have any questions, suggestions for what symbols should be added, or other feature requests, you can contact me here: <br>

Twitter: <br>
[@tomnific](https://www.twitter.com/tomnific "Tom's Twitter") <br>

Email: <br>
[tom@southernderd.us](tom@southernderd.us "Tom's Email") <br>
