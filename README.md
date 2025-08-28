# Secure EC2 Hardening Role

This Ansible role provides a **baseline security configuration** for Ubuntu-based EC2 instances. It automates system updates, enforces account-level protections, configures PAM lockouts, and adjusts SSH settings to reduce attack surface. Every task is deliberate, minimal, and built from real-world testing.

> **Note:** Root login and password-based SSH authentication are **not disabled here**—because AWS EC2 instances already ship with those restrictions by default. This role respects that baseline and builds on it.

---

## What This Role Does

| Task | Purpose | Impact |
|------|--------|--------|
| **System Update** | Ensures the latest packages and security patches are applied | Reduces exposure to known vulnerabilities |
| **Legacy Package Removal** | Purges insecure services like `telnet`, `rsh`, `xinetd` | Eliminates attack vectors commonly exploited in misconfigured systems |
| **Unattended Upgrades** | Installs and configures automatic security updates | Keeps the system patched without manual intervention |
| **User Provisioning** | Creates a secure user | Avoids root usage and enforces controlled access |
| **Password Aging via `chage`** | Sets max/min password age, warning, inactivity, and expiry | Enforces password hygiene and account lifecycle policies |
| **PAM Lockout via `pam_faillock`** | Locks user after 3 failed login attempts for 10 minutes | Prevents brute-force attacks and credential stuffing |
| **SSH Port Change** | Moves SSH to port `58222` and restarts the service | Reduces automated scanning and bot traffic on port 22 |
| **Sysctl Hardening** | Sets kernel-level parameters like `tcp_syncookies` and disables ICMP redirects | Improves resilience against network-based attacks |
| **Lynis Installation** | Installs the Lynis auditing tool from package manager | Enables local security auditing and compliance checks |
| **Lynis Audit Automation** | Deploys a custom script and schedules daily audits via cron | Ensures continuous monitoring and logs results to `/var/log/lynis/` |

---

## ⚠️ Very Important Note

If you change the SSH port to `58222`, **you must allow inbound traffic on port 58222 in your EC2 security group**.  
Failure to do so will result in being locked out of the instance.  
Make sure to allow **Custom TCP traffic on port 58222** from your IP or trusted sources.

---

## Role Variables

Defined in `defaults/main.yml`:

```yaml
new_user: zayn
user_password: !vault |  # Encrypted with ansible-vault encrypt_string
max_days: 90
min_days: 7
warn_days: 14
inactive_days: 10
expiring_date: 2025-12-31
os_security_packages_list:
  - xinetd
  - inetd
  - ypserv
  - telnet-server
  - rsh-server
  - prelink
os_security_packages_clean: true
```

> **Note:** I didn’t create a separate vault file—because this role only contains one secret, and maintaining a full vault structure wasn’t worth the overhead. To generate the encrypted password string, I used:


```sh
ansible-vault encrypt_string 'PutYourPasswordHere' --name 'user_password'
## Now run the playbook like this : 
ansible-playbook main.yml -i inventory.ini --ask-vault-pass
```


## Author  
**Zayn-Mohamad**



## License  
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

