clamav-daily
============

ClamAV is an open source (GPL) antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats.

The script scans pre-defined system locations depending on the day of the week and sends an email notification with a ClamAV log attached if any malware has been found.

# Installation on CentOS 6.x (Will possibly work on 7 but it is untested yet)

The following packages are used by the script:
 
* ClamAV
* mail/mailx depending on what you choose
 
To install:

<pre># yum install clamav clamd mailx</pre>

# Configuration

For systems that are up 24/7, you may want to put the script under cron <code>/etc/cron.daily/</code> for a daily execution.
