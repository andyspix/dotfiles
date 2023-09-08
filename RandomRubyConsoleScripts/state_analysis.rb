state_changes = StateChangeHistory.pluck(:state, :previous_state).tally

# Sorted by frequency
ap state_changes.sort_by { |k,v| v }.map { |k,v| "#{k[1].nil? ? 'nil' : k[1]} -> #{k[0].nil? ? 'nil' : k[0]} :: #{v}" }

last_used_map = state_changes.keys.map { |x, y| StateChangeHistory.where(state: x, previous_state: y).order(id: :desc).pluck(:state, :previous_state, :created_at) }
lum = last_used_map.map {|x,y,z| [[x,y], z]}.to_h
state_changes.map { |x,y| [x.join('->'), y, lum[x]] }


