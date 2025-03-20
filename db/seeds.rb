require 'faker'

puts "cleaning database"

Appointment.destroy_all
User.destroy_all
Patient.destroy_all
Group.destroy_all
Pathology.destroy_all
Note.destroy_all

group_1 = Group.create!

puts "creating users"
User.create!(first_name: "Léo", last_name: "Martin",  email: "leo@gmail.com", password: "password", group: group_1)
User.create!(first_name: "Clara", last_name: "Dupont",  email: "clara@gmail.com", password: "password", group: group_1)
User.create!(first_name: "Hugo", last_name: "Lefevre",  email: "hugo@gmail.com", password: "password", group: group_1)
User.create!(first_name: "Bruno", last_name: "Gavrel",  email: "bruno@gmail.com", password: "password", group: group_1)


puts "creating patients"
Patient.create!(first_name: "Sophie", last_name:"Moreau", address: "5 Rue Centrale, 69210 L'Arbresle", date_of_birth: "15/02/1983", phone_number: "06 12 34 56 78", social_security_number: "2 83 07 91 321 876 69", mutual: "Harmonie Mutuelle",referring_doctor:"Dr. Lucie Bernard", group: group_1)
Patient.create!(first_name: "Alexandre", last_name:"Petit", address: "12 Avenue du Général de Gaulle, 69160 Tassin-la-Demi-Lune", date_of_birth: "27/06/1965", phone_number: "07 98 76 54 32", social_security_number: "1 65 10 22 654 321 57", mutual: "MGEN",referring_doctor:"Dr. Pierre Lemoine", group: group_1)
Patient.create!(first_name: "Marion", last_name:"Gauthier", address: "31 Avenue du Chater, 69340 Francheville", date_of_birth: "03/11/1979", phone_number: "06 45 23 87 19", social_security_number: "2 79 08 77 987 654 40", mutual: "MAIF",referring_doctor:"Dr. Sophie Durand", group: group_1)
Patient.create!(first_name: "Thomas", last_name:"Mercier", address: "8 Rue de la Mairie, 69670 Vaugneray", date_of_birth: "09/04/1950", phone_number: "07 11 22 33 44", social_security_number: "1 50 05 95 456 789 33", mutual: "MACIF",referring_doctor:"Dr. Antoine Lefevre", group: group_1)
Patient.create!(first_name: "Isabelle", last_name:"Leclerc", address: "1 Route de Lentilly, 69890 La Tour-de-Salvagny", date_of_birth: "22/12/1973", phone_number: "06 88 77 66 55", social_security_number: "2 73 01 83 234 567 15", mutual: "Mutuelle Générale",referring_doctor:"Dr. Claire Moreau", group: group_1)
Patient.create!(first_name: "François", last_name:"Girard", address: "14 Rue des Aqueducs, 69126 Brindas", date_of_birth: "17/08/1960", phone_number: "07 54 32 10 98", social_security_number: "1 60 09 44 345 678 92", mutual: "AG2R",referring_doctor:"Dr. Thomas Gauthier", group: group_1)
Patient.create!(first_name: "Lea", last_name:"Blanchet", address: "21 Avenue Maréchal Foch, 69630 Chaponost", date_of_birth: "10/07/1945", phone_number: "06 33 44 55 66", social_security_number: "2 45 12 25 678 987 65", mutual: "Apivia Mutuelle",referring_doctor:"Dr. Emilie Dufresne", group: group_1)
Patient.create!(first_name: "Vincent", last_name:"Dubois", address: "41 Route de Lyon, 69530 Brignais", date_of_birth: "05/02/1958", phone_number: "07 67 89 12 34", social_security_number: "1 58 02 06 789 321 48", mutual: "La Mutuelle Familiale",referring_doctor:"Dr. Marc Lefevre", group: group_1)
Patient.create!(first_name: "Melanie", last_name:"Roussel", address: "200 Avenue du Casino, 69890 La Tour-de-Salvagny", date_of_birth: "14/11/1967", phone_number: "06 29 48 57 36", social_security_number: "2 67 06 51 543 210 73", mutual: "MNT",referring_doctor:"Dr. Isabelle Charrier", group: group_1)
Patient.create!(first_name: "Pierre", last_name:"Chaize", address: "23 Avenue Charles de Gaulle, 69160 Tassin-la-Demi-Lune", date_of_birth: "28/01/1951", phone_number: "07 90 81 72 63", social_security_number: "1 51 11 75 456 123 50", mutual: "Mutuelle Bleue",referring_doctor:"Dr. Hugo Roussel", group: group_1)
Patient.create!(first_name: "Laura", last_name:"Simon", address: "9 Place Abbé Larue, 69370 Saint-Didier-au-Mont-d'Or", date_of_birth: "02/03/1978", phone_number: "06 74 85 96 07", social_security_number: "2 78 03 44 890 765 24", mutual: "April",referring_doctor:"Dr. Marion Simon", group: group_1)
Patient.create!(first_name: "Paul", last_name:"Charrier", address: "3 Impasse du Château, 69210 Lentilly", date_of_birth: "15/07/1953", phone_number: "07 22 33 44 55", social_security_number: "1 53 10 94 123 987 39", mutual: "AESIO",referring_doctor:"Dr. François Vasseur", group: group_1)
Patient.create!(first_name: "Charlotte", last_name:"Picard", address: "35 Avenue Edouard Millaud, 69290 Craponne", date_of_birth: "26/10/1961", phone_number: "06 98 87 76 65", social_security_number: "2 61 04 34 678 234 53", mutual: "MAIF",referring_doctor:"Dr. Charlotte Dupont", group: group_1)
Patient.create!(first_name: "Samuel", last_name:"Roche", address: "8 Chemin du Moulin, 69380 Marcilly-d'Azergues", date_of_birth: "11/05/1958", phone_number: "07 45 56 67 78", social_security_number: "1 58 12 31 567 345 66", mutual: "MACIF",referring_doctor:"Dr. Jérôme Tanguy", group: group_1)
Patient.create!(first_name: "Amélie", last_name:"Fontaine", address: "3 Route de Sain-Bel, 69280 Marcy-l'Étoile", date_of_birth: "03/09/1969", phone_number: "06 10 20 30 40", social_security_number: "2 69 09 59 432 876 21", mutual: "MGEN",referring_doctor:"Dr. Caroline Robert", group: group_1)
Patient.create!(first_name: "Nicolas", last_name:"Dufresne", address: "1615 Route de la Tour, 69890 La Tour-de-Salvagny", date_of_birth: "22/12/1949", phone_number: "07 59 68 77 86", social_security_number: "1 49 07 33 234 567 94", mutual: "AG2R",referring_doctor:"Dr. Julien Favier", group: group_1)
Patient.create!(first_name: "Camille", last_name:"Lemoine", address: "7 Rue de Lyon, 69640 Ville-sur-Jarnioux", date_of_birth: "07/04/1980", phone_number: "06 87 65 43 21", social_security_number: "2 80 02 69 789 123 85", mutual: "Apivia",referring_doctor:"Dr. Catherine Faure", group: group_1)
Patient.create!(first_name: "Benoit", last_name:"Gagnon", address: "7 Avenue Lamartine, 69260 Charbonnières-les-Bains", date_of_birth: "19/06/1955", phone_number: "07 12 23 34 45", social_security_number: "1 55 08 13 321 654 47", mutual: "Mutuelle Bleue",referring_doctor:"Dr. Maxime Lefevre", group: group_1)
Patient.create!(first_name: "Claire", last_name:"Tanguy", address: "25 Route de Bordeaux, 69570 Dardilly", date_of_birth: "30/01/1972", phone_number: "06 99 88 77 66", social_security_number: "2 72 11 92 456 789 12", mutual: "AESIO",referring_doctor:"Dr. Alice Mercier", group: group_1)
Patient.create!(first_name: "Jérome", last_name:"Pires", address: "26 Route de Lyon, 69280 Sainte-Consorce", date_of_birth: "24/11/1964", phone_number: "07 31 42 53 64", social_security_number: "1 64 05 75 123 456 78", mutual: "MGEN",referring_doctor:"Dr. David Girard", group: group_1)
Patient.create!(first_name: "Léa", last_name:"Dupont", address: "5 Place Roger Salengro, 69150 Décines-Charpieu", date_of_birth: "19/12/1946", phone_number: "07 23 45 67 89", social_security_number: "2 46 07 91 321 876 69", mutual: "Harmonie Mutuelle",referring_doctor:"Dr. Lucie Bernard", group: group_1)
Patient.create!(first_name: "Hugo", last_name:"Martin", address: "10 rue de la Soie, 69120 Vaulx-en-Velin", date_of_birth: "28/01/1961", phone_number: "06 34 56 78 90", social_security_number: "1 61 05 72 905 032 54", mutual: "MGEN",referring_doctor:"Dr. Pierre Lemoine", group: group_1)
Patient.create!(first_name: "Zoé", last_name:"Lefevre", address: "5 Rue de la Mairie, 69660 Collonges-au-Mont-d'Or", date_of_birth: "02/10/1966", phone_number: "06 45 67 89 01", social_security_number: "2 66 06 43 223 547 12", mutual: "MAIF",referring_doctor:"Dr. Sophie Durand", group: group_1)
Patient.create!(first_name: "Maxime", last_name:"Rousseau", address: "1 Place de la Nation, 69120 Vaulx-en-Velin", date_of_birth: "26/08/1964", phone_number: "06 56 78 90 12", social_security_number: "1 64 03 69 481 236 09", mutual: "MACIF",referring_doctor:"Dr. Antoine Lefevre", group: group_1)
Patient.create!(first_name: "Inès", last_name:"Lemoine", address: "23 rue Sainte-Marguerite , 69110 Sainte-Foy-lès-Lyon", date_of_birth: "13/02/1950", phone_number: "07 67 89 01 23", social_security_number: "2 50 09 15 357 689 23", mutual: "Mutuelle Générale",referring_doctor:"Dr. Claire Moreau", group: group_1)
Patient.create!(first_name: "Théo", last_name:"Giraud", address: "45 Avenue Charles de Gaulle, 69160 Tassin la Demi-Lune", date_of_birth: "09/01/1937", phone_number: "06 78 90 12 34", social_security_number: "1 37 06 27 519 742 11", mutual: "AG2R",referring_doctor:"Dr. Thomas Gauthier", group: group_1)
Patient.create!(first_name: "Camille", last_name:"Bouvier", address: "49 Avenue Gabriel Péri, 69120 Vaulx-en-Velin", date_of_birth: "31/01/1937", phone_number: "07 89 01 23 45", social_security_number: "2 37 04 67 692 473 04", mutual: "Apivia Mutuelle",referring_doctor:"Dr. Emilie Dufresne", group: group_1)
Patient.create!(first_name: "Lucas", last_name:"Bertin", address: "56 Boulevard de la Croix-Rousse, 69001 Lyon", date_of_birth: "31/01/1936", phone_number: "06 90 12 34 56", social_security_number: "1 36 03 12 831 150 66", mutual: "La Mutuelle Familiale",referring_doctor:"Dr. Marc Lefevre", group: group_1)
Patient.create!(first_name: "Clara", last_name:"Hernandez", address: "5 rue du 8 Mai 1945, 69100 Villeurbanne", date_of_birth: "13/03/1952", phone_number: "06 01 23 45 67", social_security_number: "2 52 02 56 845 213 75", mutual: "MNT",referring_doctor:"Dr. Isabelle Charrier", group: group_1)
Patient.create!(first_name: "Nathan", last_name:"Lefevre", address: "78 Avenue des Frères Lumière, 69008 Lyon", date_of_birth: "10/06/1959", phone_number: "06 11 22 33 44", social_security_number: "1 59 08 34 742 506 08", mutual: "Mutuelle Bleue",referring_doctor:"Dr. Hugo Roussel", group: group_1)
Patient.create!(first_name: "Chloé", last_name:"Benoit", address: "2 rue de l'industrie, 69100 villeurbanne", date_of_birth: "08/11/1958", phone_number: "07 22 33 44 55", social_security_number: "2 58 07 45 210 638 59", mutual: "April",referring_doctor:"Dr. Marion Simon", group: group_1)
Patient.create!(first_name: "Martin", last_name:"Renaud", address: "24 cours de la Liberté, 69003 Lyon", date_of_birth: "14/01/1975", phone_number: "06 33 44 55 66", social_security_number: "1 75 03 69 845 920 50", mutual: "AESIO",referring_doctor:"Dr. François Vasseur", group: group_1)
Patient.create!(first_name: "Alice", last_name:"Vasseur", address: "15 rue des Alpes, 69200 Venissieux", date_of_birth: "28/11/1950", phone_number: "07 44 55 66 77", social_security_number: "2 50 04 27 314 895 66", mutual: "MAIF",referring_doctor:"Dr. Charlotte Dupont", group: group_1)
Patient.create!(first_name: "Louis", last_name:"Gauthier", address: "18 Rue du Président Edouard Herriot, 69001 Lyon", date_of_birth: "04/02/1952", phone_number: "05 55 66 77 88", social_security_number: "1 52 06 13 542 781 32", mutual: "MACIF",referring_doctor:"Dr. Jérôme Tanguy", group: group_1)
Patient.create!(first_name: "Emma", last_name:"Bailly", address: "32 Rue de la République, 69120 Vaulx-en-Velin", date_of_birth: "07/03/1959", phone_number: "06 66 77 88 99", social_security_number: "2 59 05 62 198 674 88", mutual: "MGEN",referring_doctor:"Dr. Caroline Robert", group: group_1)


reasons = [
  "Prise de sang",
  "Bas de contentions",
  "Vaccin covid",
  "Sinusite chronique",
  "Pansement simple",
  "Pansement complexe",
  "Soins post-opératoires",
  "Suivi diabétique (glycémies, insuline)",
  "Perfusion",
  "Ablation de points",
  "Surveillance de tension artérielle",
  "Distribution hebdomadaire de pilulier",
  "Soins palliatifs",
  "Surveillance d’escarres et soins préventifs",
  "Prise en charge des troubles veineux",
  "Soins de sonde urinaire",
  "Surveillance post-chimiothérapie",
  "Soins de plaies chroniques",
  "Soins de stomie",
  "Soins de trachéotomie",
  "Injection d’antibiotiques",
  "Prise de température",
  "Suivi cardiaque (ECG, surveillance)",
  "Dépistage de la grippe",
  "Soins de cathéter veineux central",
  "Prise de prélèvements",
  "Soins d'ulcères de pression",
  "Soins de brulures",
  "Vérification fonctionnement des appareils médicaux",
  "Rééducation fonctionnelle",
  "Surveillance post-opératoire",
  "Soins dentaires",
  "Drainage d’hématomes",
  "Soins de pansements avec sutures",
  "Soins de kinésithérapie respiratoire",
  "Surveillance de la fonction rénale"
]

summaries = [
  "",
  "",
  "",
  "",
  "",
  "",
  "Tout est Ok, fin des rdvs programmés",
  "Retour de l'infection, prévoir rdv médecin traitant",
  "Bandages a prévoir moins serrés",
  "Prise de sang réalisée, en attente résultats",
  "Vaccin Covid fait, aucune réaction immédiate",
  "Sinusite persistante, conseiller un RDV ORL",
  "Pansement simple refait, cicatrisation propre",
  "Pansement complexe, amélioration visible",
  "Soins post-opératoires OK, retrait points prévu mercredi",
  "Glycémies stables, insuline bien gérée",
  "Points retirés, cicatrice propre",
  "Tension artérielle normale aujourd'hui",
  "Soins palliatifs assurés, famille présente et rassurée",
  "Post-chimiothérapie : fatigue marquée, repos conseillé",
  "Surveillance escarre : pas d’aggravation, repositionnement conseillé",
  "Prise en charge de la douleur satisfaisante, traitement ajusté",
  "Vaccin fait, surveillance de 30 minutes sans réaction",
  "Surveillance tension artérielle : légère variation, à suivre",
  "Pansement simple refait, bonne évolution de la plaie",
  "Sinusite chronique, traitement médicamenteux en cours",
  "Ablation de points réussie, cicatrisation rapide",
  "Suivi diabétique : glycémies sous contrôle, pas d’hypoglycémie",
  "Soins post-opératoires bien tolérés, pas de complications",
  "Perfusion bien tolérée, aucune réaction indésirable",
  "Surveillance post-opératoire : plaie propre, aucun signe d’infection",
  "Retour du patient avec fièvre, consulter pour suivi",
  "Soins de stomie : hygiène correcte, pas d’infection",
  "Pansement complexe refait, légère amélioration",
  "Prise de sang réalisée, suivi recommandé dans 48h",
  "Soins palliatifs poursuivis, patient apaisé et stable"
]

puts "creating appointments"

start_date = Date.new(2025, 3, 10)
end_date = Date.new(2025, 4, 27)

available_hours = [
  { start: [6, 30], end: [7, 30] },
  { start: [7, 40], end: [8, 30] },
  { start: [8, 40], end: [9, 30] },
  { start: [9, 45], end: [10, 45] },
  { start: [11, 0], end: [12, 0] },
  { start: [12, 10], end: [13, 0] },
  { start: [13, 30], end: [14, 40] },
  { start: [15, 0], end: [15, 50] },
  { start: [16, 0], end: [17, 0] },
  { start: [17, 10], end: [18, 0] },
  { start: [18, 10], end: [19, 0] },
  { start: [19, 10], end: [20, 0] },

]
(start_date..end_date).each do |appointment_date|

  daily_hours = available_hours.shuffle.sample(rand(1..8))

  daily_hours.each do |hour|
    start_time = Time.new(appointment_date.year, appointment_date.month, appointment_date.day, hour[:start][0], hour[:start][1], 0)
    end_time = Time.new(appointment_date.year, appointment_date.month, appointment_date.day, hour[:end][0], hour[:end][1], 0)

    Appointment.create!(
      date: appointment_date,
      start_time: start_time,
      end_time: end_time,
      user: User.last,
      patient: Patient.all.sample,
      reason: reasons.sample,
      summary: summaries.sample
    )
  end
end

puts "creating pathologies"
pathologies_list = [
  "Hypertension artérielle",
  "Diabète de type 2",
  "Asthme chronique",
  "Arthrite rhumatoïde",
  "Allergie saisonnière",
  "Insuffisance cardiaque",
  "Hypothyroïdie",
  "Cholestérol élevé",
  "Troubles digestifs",
  "Problèmes rénaux",
  "Sclérose en plaques",
  "Maladie de Crohn",
  "Antécédent de crise cardiaque",
  "Bronchite chronique",
  "Migraines fréquentes",
  "Eczéma",
  "Fibromyalgie",
  "Hernie discale",
  "Polyarthrite ankylosante",
  "Ulcère gastrique",
  "Algie vasculaire de la face",
  "Parkinson",
  "Epilepsie",
  "Insuffisance respiratoire chronique",
  "Troubles anxieux généralisés",
  "Trouble bipolaire",
  "Arthrose",
  "Spondylarthrite ankylosante,",
  "Syndrome de Raynaud",
  "Lupus érythémateux",
  "Apnée du sommeil",
  "Cœliaque (intolérance au gluten)",
  "Maladie d'Alzheimer",
  "Hépatite chronique",
  "Endométriose",
  "Anémie ferriprive"
]

Patient.all.each do |patient|
  rand(1..3).times do
    Pathology.create!(
      patient: patient,
      description: pathologies_list.sample,
      created_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
    )
  end
end

puts "creating notes"
notes_content = [
  "RAS",
  "Prévoir un suivi médical après la prochaine visite.",
  "Patient améliore bien suite au dernier traitement.",
  "Attention au régime alimentaire indiqué.",
  "A subi une intervention récente, vigilance sur les points de suture.",
  "Constat d'une augmentation de la tension artérielle.",
  "Pas de nouvelles observations lors de cette visite.",
  "Patient nécessite une attention accrue pour ses médicaments.",
  "Problèmes de déplacement notés, assistance possible.",
  "A signalé une douleur au niveau du bas du dos ; à surveiller.",
  "Cicatrisation en bonne évolution, contrôle dans 48h",
  "Injection bien tolérée, aucune réaction immédiate",
  "Pansement refait, léger écoulement à surveiller",
  "Patient fatigué, repos recommandé",
  "Oedème léger constaté, surveillance renforcée",
  "Patient confus ce jour, prévenir entourage et médecin traitant",
  "Suivi glycémique stable, continuer surveillance quotidienne",
  "Sonde bien positionnée, pas de signe d’infection",
  "Famille informée des soins à poursuivre",
  "Essoufflement signalé à l’effort, à évaluer si persistant",
  "Ordonnance manquante pour renouvellement, à demander au médecin traitant",
  "Suivi de la douleur à ajuster en fonction des symptômes",
  "Réaction légère à l'allergie, vérifier la prise d'antihistaminiques",
  "Vigilance sur la prise de médicaments à heure fixe",
  "Cicatrice propre, pas d'infection visible à ce jour",
  "Contrôle de la tension artérielle recommandé dans une semaine",
  "Patient présente une légère léthargie, à surveiller au besoin",
  "Recommandation pour augmenter l’hydratation en cas de sécheresse cutanée",
  "Réajuster le traitement de fond suite à un retour de symptômes",
  "Douleur thoracique occasionnelle, à signaler en cas d'aggravation",
  "Aucun signe de déshydratation, continuer à encourager la prise de liquides",
  "Réaction post-vaccinale légère, prévoir surveillance",
  "Patient montre des signes de stress, évaluation psychologique recommandée",
  "Suivi de la fonction hépatique nécessaire suite à traitement prolongé",
  "Équilibre glycémique à surveiller sur les prochaines semaines",
  "Surveillance de la température corporelle recommandée après la prise d'antibiotiques"

]

Patient.all.each do |patient|
  rand(2..5).times do
    Note.create!(
      patient: patient,
      text: notes_content.sample,
      created_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
    )
  end
end

puts "finished"
