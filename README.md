# boostrap-ansible

Simple script to install Ansible via Homebrew on Debian based systems.

The script is tested against a docker container.

## Testing

To test the script:

```bash
make test
```

NOTE: The Docker container tries to resemble as much as posible a regular Ubuntu box, running as a non privileged user and using an init system.
