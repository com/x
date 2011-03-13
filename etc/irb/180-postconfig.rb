require 'ap'
FancyIrb.start	:rocket_mode   => true,
		:colorize      => {
			:output => false,
        		:rocket_prompt => :light_cyan,
        		:result_prompt => :light_cyan,
			# :stdout        => :light_gray,
		},
               :result_proc   => proc { |context|
                        context.last_value.awesome_inspect
                }
