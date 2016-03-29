# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

now = Time.now
today = Date.today

assembly_count = 10
sequence_count = 10000
gene_count = 50000
hit_count = 500000

puts_interval = 100

dna_characters = ["A", "C", "T", "G"]

dna_string = ""
1500.times do
  dna_string << dna_characters.sample
end

assemblies = []
assembly_count.times do |i|
  a = Assembly.new(run_on: today - rand(100).days,
    name: "a#{i+1}")
  assemblies << a
end
Assembly.import assemblies

sequences = []
sequence_count.times do |i|
  s = Sequence.new(assembly_id: rand(assembly_count) + 1,
    dna: dna_string[rand(700)..(-1*rand(700))],
    quality: Faker::Lorem.characters(10))
  sequences << s
end
Sequence.import sequences

genes = []
gene_count.times do |i|
  g = Gene.new(sequence_id: rand(sequence_count) + 1,
    dna: dna_string[rand(700)..(-1*rand(700))],
    starting_position: rand(100),
    direction: rand(2)==1)
  genes << g
end
Gene.import genes

hits = []
hit_count.times do |i|
  h = Hit.new(subject_id: rand(gene_count) + 1,
      subject_type: "Gene",
      match_gene_name: Faker::Lorem.word,
      match_gene_dna: dna_string[rand(700)..(-1*rand(700))],
      percent_similarity: rand(100))
  hits << h
end
Hit.import hits

puts "Completed running in #{Time.now-now} seconds."
