use Mix.Config

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_time, :servers, [
  "0.pool.ntp.org",
  "1.pool.ntp.org",
  "2.pool.ntp.org",
  "3.pool.ntp.org"
]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "moon.local",
  node_name: nil,
  node_host: :mdns_domain

config :nerves_network,
  regulatory_domain: "US"

config :nerves_network, :default,
  wlan0: [
    networks: [
      [
        ssid: System.get_env("NERVES_NETWORK_SSID"),
        psk: System.get_env("NERVES_NETWORK_PSK"),
        key_mgmt: String.to_atom(key_mgmt),
        ipv4_address_method: :dhcp
      ]
    ]
  ]

  config :tzdata, :data_dir, "/root/elixir_tzdata_data"

import_config "blinkchain.exs"
