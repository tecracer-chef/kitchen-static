# Kitchen::Static: A Test Kitchen Driver for Existing Hosts

This is a Test Kitchen driver for use in cases, where you have an
existing machine, such as a physical server which you want
to use for your tests.

The static driver is directly derived from TK's "proxy" driver,
which is relying on legacy plugin infrastructure - making it directly
incompatible with Windows platforms.

## Usage

```
---
driver:
  name: static
  host: 192.168.14.2

# now the rest of your kitchen.yml follows
```

The `host` configuration setting, which specifies the hostname/IP you want tests
to run against.

If you have more than one server, for example when testing specific hardware
drivers, just add a suite for each and override the `host` value in its
section

## Supported Platforms

As this is a pure driver which does not interact with the instances/VMs, it
supports all platforms. Specifically Linux and Windows are known to work.

## Queueing Feature

As physical machines are a limited resource and are rarely bought or thrown
away in a TestKitchen context, some sort of queueing mechanism is needed in
bigger environments.

To enable this feature, set `queueing` to `true` (default: `false`)

```yaml
driver:
  name: static
  queueing: true
  request:
    execute: /usr/local/bin/get-host.sh
  release:
    execute: /usr/local/bin/release-host.sh $STATIC_HOSTNAME
      ...
```

Queueing knows two Actions:

* `request` to obtain the hostname or IP of the machine to use
* `release` to return this host into the pool

If you are using non-ephemeral test systems, like physical machines, you will
need to trigger some procedure to reset them back to the defined default. Otherwise,
every test will modify the system further until results get unpredictable.

There currently is just one handler for queueing scenarios:

* the `script` handler, which executes a local script

## Driver Options

| Name                | Default   | Description                                   |
| ------------------- | --------- | --------------------------------------------- |
| `queueing`          | false     | If to invoke external actions to get hostname |
| `queueing_timeout`  | 3600      | Timeout for queueing operations in seconds.   |
| `queueing_handlers` | -         | Glob to load external queueing handlers       |

## Queueing Handler `static`

This handler only executes local commands. These could query remote databases or
even issue more complex programs to obtain/release machines.

### Parameters for `request`

| Name             | Default   | Description                                                |
| ---------------- | --------- | ---------------------------------------------------------- |
| `type`           | `script`  |                                                            |
| `execute`        | -         | Command to execute                                         |
| `match_hostname` | `^(.*)$`  | Regex to specify what to grab from output. Default: All    |
| `match_banner`   | -         | Regex to specify optional banner to grab. Default: Nothing |

If a banner is grabbed, it's contents are displaed after the message reporting the
hostname. This field can be used for warnings or additional information like access
to management interfaces (ILO, BMC, ...).

### Parameters for `release`

| Name       | Default   | Description                                             |
| ---------- | --------- | ------------------------------------------------------- |
| `type`     | `script`  |                                                         |
| `execute`  | -         | Command to execute                                      |

The executed script gets the following environment variables:

* `STATIC_HOSTNAME`: Hostname or IP of the host to be released

## License

Apache 2.0 (see [LICENSE][license])

[license]:          https://github.com/tecracer_theinen/kitchen-static/blob/master/LICENSE
