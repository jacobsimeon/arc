tables = Hash.new do |hash, key|
  hash[key] = Arel::Table.new key
end
file_root = File.expand_path("../", __FILE__)
data = {
  :superheros => 
  [
    {
      :name => 'superman',
      :born_on => Time.now,
      :photo => File.read("#{file_root}/resources/superman.gif"),
      :created_at => Time.now
    },
    {
      :name => 'ironman',
      :born_on => Time.now,
      :photo => File.read("#{file_root}/resources/ironman.gif"),
      :created_at => Time.now
    },
    {
      :name => 'megaman',
      :born_on => Time.now,
      :photo => File.read("#{file_root}/resources/megaman.jpg"),
      :created_at => Time.now
    }
  ],
  :powers => 
  [
    {
      :name => 'flight',
      :description => "The ability to levitate in and move through the air.",
    },
    {
      :name => 'money',
      :description => 'The ability to act like the billionaire owner of apple computer.'
    },
    {
      :name => 'ice blaster',
      :description => 'Not really a power, but hey.  It shoots ice.'
    }
  ]
}

ids = {:superheros => {}, :powers => {}}

data.each_pair do |name, tuples|  
  table = tables[name]
  delete = Arel::DeleteManager.new Arel::Table.engine
  Arel::Table.engine.destroy delete.from(table).to_sql
  
  tuples.each do |tuple|
    stmt = Arel::InsertManager.new Arel::Table.engine
    values = tuple.keys.map do |key|
      [table[key], tuple[key]]
    end
    stmt.insert(values)
    record = Arel::Table.engine.create(stmt.to_sql)
    ids[name][record[:name]] = record[:id]
  end
end
power_map = Arel::Table.new :superheros_powers

power_sets = [
  ['superman', 'flight'],
  ['ironman', 'money']
]
power_sets.each do |set|
  im = Arel::InsertManager.new Arel::Table.engine
  im.insert([
    [power_map[:superhero_id], ids[:superheros][set[0]]],
    [power_map[:power_id], ids[:powers][set[1]]]
  ])
  Arel::Table.engine.create im.to_sql
end
