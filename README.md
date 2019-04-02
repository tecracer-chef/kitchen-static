# Kitchen::Static: A Test Kitchen Driver for Existing Hosts

This is a Test Kitchen driver for use in cases, where you have an
existing machine, such as a physical server which you want
to use for your tests.

The static driver is directly derived from TK's "proxy" driver, 
which is relying on legacy plugin infrastructure - making it directly incompatible
with Windows platforms.

## Usage

```
---
driver:
  name: static
  host: 192.168.14.2

# now the rest of your kitchen.yml follows
```

The `host` configuration setting, which specifies the hostname/IP you want tests to run against.

If you have more than one server, for example when testing specific
hardware drivers, just add a suite for each and override the
`host` value in its section

## Supported Platforms

As this is a pure driver which does not interact with the
instances/VMs, it supports all platforms. Specifically Linux
and Windows work.

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])

[license]:          https://github.com/tecracer_theinen/kitchen-static/blob/master/LICENSE
