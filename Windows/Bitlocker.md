BitLocker

1\. Check For TPM and Bios Mode:

<table>
<tbody>
<tr class="odd">
<td><p>Check <strong>Device Manager</strong> to see if "security
devices" is listed. If not, does not have TPM.</p>
<p>TPM:</p>
<p>Clear TPM Module – Bitlocker setup menu / TPM Administration. Status
should say: " The TPM is ready for use." - May have to be done after
step two...</p>
<p>Bios:</p>
<p>Should be set to <strong>UEFI</strong> -not Legacy</p></td>
</tr>
</tbody>
</table>

2\. Group Policy Edit:

<table>
<tbody>
<tr class="odd">
<td><p>Change Drive encryption method:</p>
<p>Computer Configuration &gt; Administrative Templates &gt; Windows
Components &gt; BitLocker Drive Encryption &gt; Choose drive encryption
method and cipher strength.</p>
<p>Group Policy editor - Operatiang System Drives:</p>
<p>Head to Computer Configuration &gt; Administrative Templates &gt;
Windows Components &gt; BitLocker Drive Encryption &gt; Operating System
Drives in the Group Policy window. </p>
<p>There are several other Group Policies that can be configured but are
not required, including:</p>
<p>"Allow enhanced PINs for startup"</p></td>
</tr>
</tbody>
</table>

3\. Create Keys:

<table>
<tbody>
<tr class="odd">
<td><p>Master Recovery (USB) Startup Key:</p>
<p>manage-bde -protectors -add C: -RecoveryKey
"%userprofile%\Downloads"</p>
<p>Without TPM Module:</p>
<p>Bitlocker can only be enabled without tpm with a (USB) startupkey or
password, not both.</p>
<p>manage-bde -protectors -add C: -password // Will prompt for
password.</p>
<p>With TPM Module:</p>
<p>manage-bde -protectors -add C: -tpsk -tp "Password" -tsk G:</p>
<p>Other Commands:</p>
<p>View all Protectors:</p>
<p>manage-bde -protectors -get C:</p>
<p>Change Password:</p>
<p><strong>manage-bde -changepassword C: </strong> //Will Promt for
password.</p>
<p>Add another unlock password,</p>
<p><strong>manage-bde -protectors -add C: -tpmandpin</strong> // if tpm
module is present.</p>
<p>Check Status:</p>
<p>manage-bde -status</p>
<p>Turn On and Off Encryption:</p>
<p>manage-bde -on C:</p>
<p>manage-bde -off C:</p>
<p>Backup Recovery Key:</p>
<p>manage-bde -protectors -get C: &gt; G:Bryon_Recovery_Key.txt</p>
<p>Add extra (USB) startup key: </p>
<p>manage-bde -add C: -StartupKey D:</p>
<p>To delete protector keys:</p></td>
</tr>
</tbody>
</table>

Registry script to change settings.

<table>
<tbody>
<tr class="odd">
<td><p>Windows Registry Editor Version 5.00</p>
<p>[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE]</p>
<p>"UseAdvancedStartup"=dword:00000001</p>
<p>"EnableBDEWithNoTPM"=dword:00000001</p>
<p>"UseTPM"=dword:00000002</p>
<p>"UseTPMPIN"=dword:00000002</p>
<p>"UseTPMKey"=dword:00000002</p>
<p>"UseTPMKeyPIN"=dword:00000002</p>
<p>Create bat file：</p>
<p>@ECHO OFF</p>
<p>REG IMPORT C:\EnableNoTPM.reg</p>
<p>EXIT</p>
<p>You can still use BitLocker with a laptop that does not contain a TPM
chip, by enabling a local group policy. Open Local Group Policy Editor
(gpedit.msc from run prompt) </p>
<p>and navigate to Computer Configuration/Administrative
Templates/Windows Components/BitLocker Drive Encryption/Operating System
Drives and enable the Require additional </p>
<p>authentication on startup policy. Then, check the option which says
"Allow BitLocker without a compatible TPM" and press OK.</p>
<p>If you enable this feature you can use BitLocker on your laptop but
the TPM module will not be used to secure the encryption key. There are
two authentication options </p>
<p>available after enabling this feature, using a startup password or by
using a smart card with a PIN code.</p>
<p>For more information, you may refer to:</p>
<p>Bitlocker without TPM</p>
<p>http://blogs.technet.com/b/hugofe/archive/2010/10/29/bitlocker-without-tpm.aspx</p>
<p>Hope it helps.</p>
<p>Regards,</p>
<p>Blair Deng</p></td>
</tr>
</tbody>
</table>

Windows 7 Bitlocker

The BitLocker GUI in the Windows 7 Control Panel supports TPM + PIN and
TPM + USB StartupKey but not **TPM + PIN + USB StartupKey**. This
configuration requires editing Group Policy and using the command line
tool manage-bde.

<span id="anchor"></span>This guide is intended for a sophisticated
audience. The consequences of following the procedure are not discussed
here.

Variations on this also work, such as Windows 7 Enterprise or a USB hard
drive instead of one of the flash drives.

- Windows 7 Ultimate
- TPM 1.2 chip on motherboard
- 2 USB flash drives
- An administrator account (use the same account throughout the entire
  process)

## 1. Setup Group Policy

In **Search programs and files** on the Start Menu,
type ****gpedit.msc****. Hold \<Shift\> + \<Ctrl\> and press \<Enter\>
to run as an administrator.

Open ****Computer Configuration -\> Administrative Templates -\> Windows
Components -\> BitLocker Drive Encryption -\> Operating System
Drives****.

Open **Require additional authentication at startup**. Be careful to
avoid the similarly named **Require additional authentication at startup
(Windows Server 2008 and Windows Vista)**.

<img src="Pictures/10000000000002B20000027FCDBDBC62.png"
style="width:6.9252in;height:6.4134in" />

**Cmd **run **gpupdate.exe** as an administrator.

<img src="Pictures/10000000000003D7000002041CF25729.png"
style="width:6.9252in;height:3.6346in" />

## 2. Setup the TPM

Open **Control Panel -\> BitLocker -\> Manage TPM** (on the bottom
left).

Initialize the TPM using the utility. A restart will probably be
required. Follow the directions in the utility carefully as well as any
directions that appear during the restart.

If a restart was required, logon. The utility will automatically open to
complete the setup. Backup the TPM owner key using the utility when
prompted.

## 3. Add a Recovery Key

In **Search programs and files** run **cmd** as an administrator.

Insert a USB flash drive and note the drive letter assigned to it.

Run the command below to add a Recovery Key. Replace F with the drive
letter assigned to the USB flash drive. C is the drive to be encrypted.
F is the location to save the Recovery Key.

manage-bde -protectors -add C: -RecoveryKey I:

Unhide protected operating system files to see .bek file.

The command should result in the output below. My key IDs have been
redacted.

<table>
<tbody>
<tr class="odd">
<td>BitLocker Drive Encryption: Configuration Tool version
6.1.7601<br />
Copyright (C) Microsoft Corporation. All rights reserved.<br />
<br />
Key Protectors Added:<br />
<br />
Saved to directory F:<br />
<br />
External Key:<br />
ID: REDACTED<br />
External Key File Name:<br />
REDACTED</td>
</tr>
</tbody>
</table>

Remove the USB flash drive and store it securely. The Recovery Key can
be used to access the drive without the TPM and PIN. This USB flash
drive is not the one that will be used to boot the computer for normal
use.

## 4. Add the TPM, PIN, and USB StartupKey

Insert the second USB flash drive and note the drive letter assigned to
it.

Run the command below to add a TPM, PIN, and USB StartupKey. Replace
REDACTED with your PIN. Although a BitLocker PIN can contain spaces, it
is easier to avoid spaces when setting the PIN via the command line.
Replace E with the drive letter assigned to the USB flash drive. C is
the drive to be encrypted. E is the location to save the StartupKey.

CHANGE REDATCED to KEY PIN

manage-bde -protectors -add C: -TPMandPINandStartupKey -tp REDACTED -tsk
I:

The command should result in the output below. My key IDs have been
redacted.

<table>
<tbody>
<tr class="odd">
<td><p>BitLocker Drive Encryption: Configuration Tool version
6.1.7601</p>
<p>Copyright (C) Microsoft Corporation. All rights reserved.</p>
<p>Key Protectors Added:</p>
<p> Saved to directory E:</p>
<p> TPM And PIN And Startup Key:</p>
<p> ID: 145B8083-94B8-4AD1-B383-AE33EBF19DF1</p>
<p> External Key File Name:</p>
<p> 145B8083-94B8-4AD1-B383-AE33EBF19DF1.BEK</p>
<p>TPM And PIN And Startup Key:</p>
<p> ID: {145B8083-94B8-4AD1-B383-AE33EBF19DF1}</p>
<p> PCR Validation Profile:</p>
<p> 0, 2, 4, 11</p>
<p> External Key File Name:</p>
<p> </p></td>
</tr>
</tbody>
</table>

Do not remove the USB flash drive.

## 5. Encrypt the drive

Run the command below to perform a hardware check and encrypt the drive.
C is the drive to be encrypted.

manage-bde -on C:

The command should result in the output below.

BitLocker Drive Encryption: Configuration Tool version 6.1.7601

Copyright (C) Microsoft Corporation. All rights reserved.

Volume C: \[\]

\[OS Volume\]

ACTIONS REQUIRED:

 1. Insert a USB flash drive with an external key file into the
computer.

2. Restart the computer to run a hardware test.

(Type "shutdown /?" for command line instructions.)

3. Type "manage-bde -status" to check if the hardware test succeeded.

NOTE: Encryption will begin after the hardware test succeeds.

Restart your computer as instructed. Logon after the restart.

If the hardware test passed the drive will be encrypted. A GUI will show
the encryption progress. If the hardware test failed the drive will not
be encrypted.

Go to Manage Bitlocker and **save backup key file to keepass**.

# 

# 

# 

# Step One: Enable BitLocker (If You Haven’t Already)

<img src="Pictures/100002010000028A0000012C4CFC0A38.png"
style="width:6.7709in;height:3.1252in" />

If you [encrypt your Windows system drive with
BitLocker](https://www.howtogeek.com/192894/how-to-set-up-bitlocker-encryption-on-windows/),
you can add a PIN for additional security. You’ll need to enter the PIN
each time you turn on your PC, before Windows will even start. This is
separate from a [login
PIN](https://www.howtogeek.com/232557/how-to-add-a-pin-to-your-account-in-windows-10/),
which you enter after Windows boots up.

A pre-boot PIN prevents the encryption key from automatically being
loaded into system memory during the boot process, which protects
against direct memory access (DMA) attacks on systems with hardware
vulnerable to them. [Microsoft’s
documentation](https://technet.microsoft.com/en-us/library/dn632176(v=ws.11).aspx) explains this
in more detail.

<img src="Pictures/100002010000028A00000153D493A3E2.png"
style="width:6.7709in;height:3.1252in" />

This is a BitLocker feature, so you have to use BitLocker encryption to
set a pre-boot PIN. This is only available on Professional and
Enterprise editions of Windows. Before you can set a PIN, you have
to [enable BitLocker for your system
drive](https://www.howtogeek.com/192894/how-to-set-up-bitlocker-encryption-on-windows/).

Note that, if you go out of your way to [enable BitLocker on a computer
without a
TPM](https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/),
you’ll be prompted to create a startup password that’s used instead of
the TPM. The below steps are only necessary when enabling BitLocker on
computers with TPMs, which [most modern computers
have](https://www.howtogeek.com/237232/what-is-a-tpm-and-why-does-windows-need-one-for-disk-encryption/).

If you have a Home version of Windows, you won’t be able to use
BitLocker. You may have the [Device
Encryption](https://www.howtogeek.com/173592/windows-8.1-will-start-encrypting-hard-drives-by-default-everything-you-need-to-know/) feature
instead, but this works differently from BitLocker and doesn’t allow you
to provide a startup key.

## Step Two: Enable the Startup PIN in Group Policy Editor

Once you’ve enabled BitLocker, you’ll need to go out of your way
to enable a PIN with it. This requires a Group Policy settings change.
To open the Group Policy Editor, press Windows+R, type “gpedit.msc” into
the Run dialog, and press Enter.

Head to **Computer Configuration \> Administrative Templates \> Windows
Components \> BitLocker Drive Encryption \> Operating System Drives in
the Group Policy window**.

Double-click the “Require Additional Authentication at Startup” Option
in the right pane.

<img src="Pictures/100002010000028A000001201D9EF48D.png"
style="width:6.7709in;height:3in" />

Select “Enabled” at the top of the window here. Then, click the box
under “Configure TPM Startup PIN” and select the “**Require Startup PIN
With TPM**” option. Click “OK” to save your changes.

<img src="Pictures/100000000000028A000002582D053AF8.jpg"
style="width:6.7709in;height:6.25in" />

## Step Three: Add a PIN to Your Drive

You can now use the **manage-bde** command to add the PIN to your
BitLocker-encrypted drive.

To do this, launch a Command Prompt window as Administrator. On Windows
10 or 8, right-click the Start button and select “Command Prompt
(Admin)”. On Windows 7, find the “Command Prompt” shortcut in the Start
menu, right-click it, and select “Run as Administrator”

Run the following command. The below command works on your C: drive, so
if you want to require a startup key for another drive, enter its drive
letter instead of **c:** .

|                                           |
|-------------------------------------------|
| manage-bde -protectors -add c: -TPMAndPIN |

You’ll be prompted to enter your PIN here. The next time you boot,
you’ll be asked for this PIN.

<img src="Pictures/100000000000028A000001A51A4B3F10.png"
style="width:6.7709in;height:4.3854in" />

To double-check whether the TPMAndPIN protector was added, you can run
the following command:

|                    |
|--------------------|
| manage-bde -status |

(The “Numerical Password” key protector displayed here is your recovery
key.)

<img src="Pictures/100000000000028A0000017562F6CBE1.png"
style="width:6.7709in;height:3.8854in" />

## How to Change Your BitLocker PIN

To change the PIN in the future, open a Command Prompt window as
Administrator and run the following command:

|                          |
|--------------------------|
| manage-bde -changepin c: |

You’ll need to type and confirm your new PIN before continuing.

<img src="Pictures/100000000000028A000000C080443528.png"
style="width:6.7709in;height:2in" />

## How to Remove the PIN Requirement

If you change your mind and want to stop using the PIN later, you can
undo this change.

First, you’ll need to head to the Group Policy window and change the
option back to “Allow Startup PIN With TPM”. You can’t leave the option
set to “Require Startup PIN With TPM” or Windows won’t allow you to
remove the PIN.

Next, open a Command Prompt window as Administrator and run the
following command:

|                                     |
|-------------------------------------|
| manage-bde -protectors -add c: -TPM |

This will replace the “TPMandPIN” requirement with a “TPM” requirement,
deleting the PIN. Your BitLocker drive will automatically unlock via
your computer’s TPM when you boot.

<img src="Pictures/100002010000028A0000009DFB63FB6C.png"
style="width:6.7709in;height:1.6354in" />

To check that this completed successfully, run the status command again:

|                       |
|-----------------------|
| manage-bde -status c: |

<img src="Pictures/100002010000028A00000154456AF049.png"
style="width:6.7709in;height:3.5417in" />

If you forget the PIN, you’ll need to provide the BitLocker recovery
code you should have saved somewhere safe when you enabled BitLocker for
your system drive.
