require 'yaml'

a =<<EOF
---
mess: "thi
...
EOF

x = YAML.load(a)
p x
