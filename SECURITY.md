# Security Policy

Please do not open public issues containing real campus account credentials,
cookies, tokens, or router passwords.

If you need to share logs, redact:

- Account names
- Passwords
- Challenge tokens
- Cookies
- Public IP addresses, if sensitive

This package stores the campus login password in `/etc/config/srun`. The
installation script sets that file to mode `600`, but anyone with root access to
the router can still read it.
