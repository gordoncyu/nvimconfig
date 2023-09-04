require('leap').add_default_mappings()
lopts = require('leap.opts')
lopts.special_keys.next_target = ';'
lopts.special_keys.prev_target = ','
require('leap-spooky').setup()
