namespace :db do
  namespace :fill do
    task :categories => :environment do
      puts "A criar Temáticas!\n"
      Category.new( :name => "Emigração"                           ).save 
      Category.new( :name => "Emigração África"                    ).save 
      Category.new( :name => "Emigração América do Norte"          ).save 
      Category.new( :name => "Emigração América Latina"            ).save
      Category.new( :name => "Emigração Ásia"                      ).save
      Category.new( :name => "Emigração Brasil"                    ).save
      Category.new( :name => "Emigração Contemporânea"             ).save
      Category.new( :name => "Emigração Europa"                    ).save
      Category.new( :name => "Imigração"                           ).save
      Category.new( :name => "Imigração África"                    ).save
      Category.new( :name => "Imigração Ásia"                      ).save
      Category.new( :name => "Imigração Brasil"                    ).save
      Category.new( :name => "Imigração Europa"                    ).save
      Category.new( :name => "Imigração Europa de Leste"           ).save
      Category.new( :name => "Diáspora e Transnacionalismo"        ).save
      Category.new( :name => "Migrações e Pós-colonialismo"        ).save
      puts "Concluido!"
    end

    task :subcategories => :environment do
      puts "A criar Descritores!\n"
      Subcategory.new( :name => "Actividades Artísticas"              ).save
      Subcategory.new( :name => "Associativismo"                      ).save
      Subcategory.new( :name => "Cidades"                             ).save
      Subcategory.new( :name => "Culturas e Identidades"              ).save
      Subcategory.new( :name => "Descendentes"                        ).save
      Subcategory.new( :name => "Escola"                              ).save
      Subcategory.new( :name => "Género"                              ).save
      Subcategory.new( :name => "Imigração Clandestina"               ).save
      Subcategory.new( :name => "Participação Política"               ).save
      Subcategory.new( :name => "Religião"                            ).save
      Subcategory.new( :name => "Trabalho"                            ).save
      puts "Concluido!"
    end

    task :genres => :environment do
      puts "A criar Generos!\n"
      Genre.new( :name => "Ficção"                                    ).save 
      Genre.new( :name => "Documentário"                              ).save 
      Genre.new( :name => "Investigação"                              ).save 
      Genre.new( :name => "Institucionais"                            ).save
      Genre.new( :name => "Amadores"                                  ).save
      Genre.new( :name => "Outros"                                    ).save
      puts "Concluido!"         
    end

    task :music_genres => :environment do
      puts "A criar Generos Musicais!\n"
      MusicGenre.new( :name => "Bandas Sonoras"                       ).save 
      MusicGenre.new( :name => "Música Popular"                       ).save 
      MusicGenre.new( :name => "Música Ligeira"                       ).save 
      MusicGenre.new( :name => "Música Erudita"                       ).save
      MusicGenre.new( :name => "Rap"                                  ).save
      MusicGenre.new( :name => "Outros"                               ).save
      puts "Concluido!"         
    end

    task :document_types => :environment do
      puts "A criar document types!\n"
      DocumentType.new( :name => "Teses"                              ).save 
      DocumentType.new( :name => "Livros"                             ).save 
      DocumentType.new( :name => "Artigos"                            ).save 
      DocumentType.new( :name => "outros"                             ).save
      puts "Concluido!"
    end

    task :countries => :environment do
      Country.new( :code=>'af', :name=>'Afghanistan').save
      Country.new( :code=>'al', :name=>'Albania').save
      Country.new( :code=>'dz', :name=>'Algeria').save
      Country.new( :code=>'as', :name=>'American Samoa').save
      Country.new( :code=>'ad', :name=>'Andorra').save
      Country.new( :code=>'ao', :name=>'Angola').save
      Country.new( :code=>'ai', :name=>'Anguilla').save
      Country.new( :code=>'aq', :name=>'Antarctica').save
      Country.new( :code=>'ag', :name=>'Antigua and Barbuda').save
      Country.new( :code=>'ar', :name=>'Argentina').save
      Country.new( :code=>'am', :name=>'Armenia').save
      Country.new( :code=>'aw', :name=>'Aruba').save
      Country.new( :code=>'ac', :name=>'Ascension Island').save
      Country.new( :code=>'au', :name=>'Australia').save
      Country.new( :code=>'at', :name=>'Austria').save
      Country.new( :code=>'az', :name=>'Azerbaijan').save
      Country.new( :code=>'bs', :name=>'Bahamas').save
      Country.new( :code=>'bh', :name=>'Bahrain').save
      Country.new( :code=>'bd', :name=>'Bangladesh').save
      Country.new( :code=>'bb', :name=>'Barbados').save
      Country.new( :code=>'by', :name=>'Belarus').save
      Country.new( :code=>'be', :name=>'Belgium').save
      Country.new( :code=>'bz', :name=>'Belize').save
      Country.new( :code=>'bj', :name=>'Benin').save
      Country.new( :code=>'bm', :name=>'Bermuda').save
      Country.new( :code=>'bt', :name=>'Bhutan').save
      Country.new( :code=>'bo', :name=>'Bolivia').save
      Country.new( :code=>'ba', :name=>'Bosnia and Herzegovina').save
      Country.new( :code=>'bw', :name=>'Botswana').save
      Country.new( :code=>'bv', :name=>'Bouvet Island').save
      Country.new( :code=>'br', :name=>'Brazil').save
      Country.new( :code=>'vg', :name=>'British Virgin Islands').save
      Country.new( :code=>'io', :name=>'British Indian Ocean Territory').save
      Country.new( :code=>'bn', :name=>'Brunei Darussalam').save
      Country.new( :code=>'bg', :name=>'Bulgaria').save
      Country.new( :code=>'bf', :name=>'Burkina Faso').save
      Country.new( :code=>'bi', :name=>'Burundi').save
      Country.new( :code=>'kh', :name=>'Cambodia').save
      Country.new( :code=>'cm', :name=>'Cameroon').save
      Country.new( :code=>'ca', :name=>'Canada').save
      Country.new( :code=>'cv', :name=>'Cape Verde').save
      Country.new( :code=>'ky', :name=>'Cayman Islands').save
      Country.new( :code=>'cf', :name=>'Central African Republic').save
      Country.new( :code=>'td', :name=>'Chad').save
      Country.new( :code=>'cl', :name=>'Chile').save
      Country.new( :code=>'cn', :name=>'China').save
      Country.new( :code=>'cx', :name=>'Christmas Island').save
      Country.new( :code=>'cc', :name=>'Cocos (Keeling) Island').save
      Country.new( :code=>'co', :name=>'Colombia').save
      Country.new( :code=>'km', :name=>'Comoros').save
      Country.new( :code=>'cg', :name=>'Congo, Republic of').save
      Country.new( :code=>'cd', :name=>'Congo, Democratic Republic of').save
      Country.new( :code=>'ck', :name=>'Cook Islands').save
      Country.new( :code=>'cr', :name=>'Costa Rica').save
      Country.new( :code=>'hr', :name=>'Croatia').save
      Country.new( :code=>'cu', :name=>'Cuba').save
      Country.new( :code=>'cy', :name=>'Cyprus').save
      Country.new( :code=>'cz', :name=>'Czech Republic').save
      Country.new( :code=>'dk', :name=>'Denmark').save
      Country.new( :code=>'dj', :name=>'Djibouti').save
      Country.new( :code=>'dm', :name=>'Dominica').save
      Country.new( :code=>'do', :name=>'Dominican Republic').save
      Country.new( :code=>'ec', :name=>'Ecuador').save
      Country.new( :code=>'eg', :name=>'Egypt').save
      Country.new( :code=>'sv', :name=>'El Salvador').save
      Country.new( :code=>'gq', :name=>'Equatorial Guinea').save
      Country.new( :code=>'er', :name=>'Eritrea').save
      Country.new( :code=>'ee', :name=>'Estonia').save
      Country.new( :code=>'et', :name=>'Ethiopia').save
      Country.new( :code=>'fk', :name=>'Falkland Islands (Malvinas)').save
      Country.new( :code=>'fo', :name=>'Faroe Islands').save
      Country.new( :code=>'fj', :name=>'Fiji').save
      Country.new( :code=>'fi', :name=>'Finland').save
      Country.new( :code=>'fr', :name=>'France').save
      Country.new( :code=>'gf', :name=>'French Guiana').save
      Country.new( :code=>'pf', :name=>'French Polynesia').save
      Country.new( :code=>'tf', :name=>'French Southern Territories').save
      Country.new( :code=>'ga', :name=>'Gabon').save
      Country.new( :code=>'gm', :name=>'Gambia').save
      Country.new( :code=>'ge', :name=>'Georgia').save
      Country.new( :code=>'de', :name=>'Germany').save
      Country.new( :code=>'gh', :name=>'Ghana').save
      Country.new( :code=>'gi', :name=>'Gibraltar').save
      Country.new( :code=>'gr', :name=>'Greece').save
      Country.new( :code=>'gl', :name=>'Greenland').save
      Country.new( :code=>'gd', :name=>'Grenada').save
      Country.new( :code=>'gp', :name=>'Guadeloupe').save
      Country.new( :code=>'gu', :name=>'Guam').save
      Country.new( :code=>'gt', :name=>'Guatemala').save
      Country.new( :code=>'gg', :name=>'Guernsey').save
      Country.new( :code=>'gn', :name=>'Guinea').save
      Country.new( :code=>'gw', :name=>'Guinea-Bissau').save
      Country.new( :code=>'gy', :name=>'Guyana').save
      Country.new( :code=>'ht', :name=>'Haiti').save
      Country.new( :code=>'hm', :name=>'Heard and McDonald Islands').save
      Country.new( :code=>'hn', :name=>'Honduras').save
      Country.new( :code=>'hk', :name=>'Hong Kong').save
      Country.new( :code=>'hu', :name=>'Hungary').save
      Country.new( :code=>'is', :name=>'Iceland').save
      Country.new( :code=>'in', :name=>'India').save
      Country.new( :code=>'id', :name=>'Indonesia').save
      Country.new( :code=>'ir', :name=>'Iran').save
      Country.new( :code=>'iq', :name=>'Iraq').save
      Country.new( :code=>'ie', :name=>'Ireland').save
      Country.new( :code=>'im', :name=>'Isle of Man').save
      Country.new( :code=>'il', :name=>'Israel').save
      Country.new( :code=>'it', :name=>'Italy').save
      Country.new( :code=>'jm', :name=>'Jamaica').save
      Country.new( :code=>'jp', :name=>'Japan').save
      Country.new( :code=>'je', :name=>'Jersey').save
      Country.new( :code=>'jo', :name=>'Jordan').save
      Country.new( :code=>'kz', :name=>'Kazakhstan').save
      Country.new( :code=>'ke', :name=>'Kenya').save
      Country.new( :code=>'ki', :name=>'Kiribati').save
      Country.new( :code=>'kp', :name=>'Korea, North').save
      Country.new( :code=>'kr', :name=>'Korea, South').save
      Country.new( :code=>'kw', :name=>'Kuwait').save
      Country.new( :code=>'kg', :name=>'Kyrgyzstan').save
      Country.new( :code=>'la', :name=>'Laos').save
      Country.new( :code=>'lv', :name=>'Latvia').save
      Country.new( :code=>'lb', :name=>'Lebanon').save
      Country.new( :code=>'ls', :name=>'Lesotho').save
      Country.new( :code=>'lr', :name=>'Liberia').save
      Country.new( :code=>'ly', :name=>'Libya').save
      Country.new( :code=>'li', :name=>'Liechtenstein').save
      Country.new( :code=>'lt', :name=>'Lithuania').save
      Country.new( :code=>'lu', :name=>'Luxembourg').save
      Country.new( :code=>'mo', :name=>'Macau').save
      Country.new( :code=>'mk', :name=>'Macedonia').save
      Country.new( :code=>'mg', :name=>'Madagascar').save
      Country.new( :code=>'mw', :name=>'Malawi').save
      Country.new( :code=>'my', :name=>'Malaysia').save
      Country.new( :code=>'mv', :name=>'Maldives').save
      Country.new( :code=>'ml', :name=>'Mali').save
      Country.new( :code=>'mt', :name=>'Malta').save
      Country.new( :code=>'mh', :name=>'Marshall Islands').save
      Country.new( :code=>'mq', :name=>'Martinique').save
      Country.new( :code=>'mr', :name=>'Mauritania').save
      Country.new( :code=>'mu', :name=>'Mauritius').save
      Country.new( :code=>'yt', :name=>'Mayotte').save
      Country.new( :code=>'mx', :name=>'Mexico').save
      Country.new( :code=>'fm', :name=>'Micronesia').save
      Country.new( :code=>'md', :name=>'Moldova').save
      Country.new( :code=>'mc', :name=>'Monaco').save
      Country.new( :code=>'mn', :name=>'Mongolia').save
      Country.new( :code=>'ms', :name=>'Montserrat').save
      Country.new( :code=>'ma', :name=>'Morocco').save
      Country.new( :code=>'mz', :name=>'Mozambique').save
      Country.new( :code=>'mm', :name=>'Myanmar').save
      Country.new( :code=>'na', :name=>'Namibia').save
      Country.new( :code=>'nr', :name=>'Nauru').save
      Country.new( :code=>'np', :name=>'Nepal').save
      Country.new( :code=>'nl', :name=>'Netherlands').save
      Country.new( :code=>'an', :name=>'Netherlands Antilles').save
      Country.new( :code=>'nc', :name=>'New Caledonia').save
      Country.new( :code=>'nz', :name=>'New Zealand').save
      Country.new( :code=>'ni', :name=>'Nicaragua').save
      Country.new( :code=>'nu', :name=>'Niue').save
      Country.new( :code=>'ne', :name=>'Niger').save
      Country.new( :code=>'ng', :name=>'Nigeria').save
      Country.new( :code=>'nf', :name=>'Norfolk Island').save
      Country.new( :code=>'mp', :name=>'Northern Mariana Islands').save
      Country.new( :code=>'no', :name=>'Norway').save
      Country.new( :code=>'om', :name=>'Oman').save
      Country.new( :code=>'pk', :name=>'Pakistan').save
      Country.new( :code=>'pw', :name=>'Palau').save
      Country.new( :code=>'ps', :name=>'Palestinian Territory, Occupied').save
      Country.new( :code=>'pa', :name=>'Panama').save
      Country.new( :code=>'pg', :name=>'Papua New Guinea').save
      Country.new( :code=>'py', :name=>'Paraguay').save
      Country.new( :code=>'pe', :name=>'Peru').save
      Country.new( :code=>'ph', :name=>'Philippines').save
      Country.new( :code=>'pn', :name=>'Pitcairn Island').save
      Country.new( :code=>'pl', :name=>'Poland').save
      Country.new( :code=>'pt', :name=>'Portugal').save
      Country.new( :code=>'pr', :name=>'Puerto Rico').save
      Country.new( :code=>'qa', :name=>'Qatar').save
      Country.new( :code=>'re', :name=>'Reunion').save
      Country.new( :code=>'ro', :name=>'Romania').save
      Country.new( :code=>'ru', :name=>'Russia').save
      Country.new( :code=>'rw', :name=>'Rwanda').save
      Country.new( :code=>'sh', :name=>'Saint Helena').save
      Country.new( :code=>'kn', :name=>'Saint Kitts and Nevis').save
      Country.new( :code=>'lc', :name=>'Saint Lucia').save
      Country.new( :code=>'pm', :name=>'Saint Pierre and Miquelon').save
      Country.new( :code=>'vc', :name=>'Saint Vincent and the Grenadines').save
      Country.new( :code=>'ws', :name=>'Samoa').save
      Country.new( :code=>'sm', :name=>'San Marino').save
      Country.new( :code=>'st', :name=>'Sao Tome and Principe').save
      Country.new( :code=>'sa', :name=>'Saudia Arabia').save
      Country.new( :code=>'sn', :name=>'Senegal').save
      Country.new( :code=>'cs', :name=>'Serbia').save
      Country.new( :code=>'sc', :name=>'Seychelles').save
      Country.new( :code=>'sl', :name=>'Sierra Leone').save
      Country.new( :code=>'sg', :name=>'Singapore').save
      Country.new( :code=>'sk', :name=>'Slovakia').save
      Country.new( :code=>'si', :name=>'Slovenia').save
      Country.new( :code=>'sb', :name=>'Solomon Islands').save
      Country.new( :code=>'so', :name=>'Somalia').save
      Country.new( :code=>'za', :name=>'South Africa').save
      Country.new( :code=>'es', :name=>'Spain').save
      Country.new( :code=>'gs', :name=>'Georgia and Sandwich Islands').save
      Country.new( :code=>'lk', :name=>'Sri Lanka').save
      Country.new( :code=>'sd', :name=>'Sudan').save
      Country.new( :code=>'sr', :name=>'Suriname').save
      Country.new( :code=>'sj', :name=>'Svalbard and Jan Mayen Islands').save
      Country.new( :code=>'sz', :name=>'Swaziland').save
      Country.new( :code=>'se', :name=>'Sweden').save
      Country.new( :code=>'ch', :name=>'Switzerland').save
      Country.new( :code=>'sy', :name=>'Syria').save
      Country.new( :code=>'tw', :name=>'Taiwan').save
      Country.new( :code=>'tj', :name=>'Tajikistan').save
      Country.new( :code=>'tz', :name=>'Tanzania').save
      Country.new( :code=>'th', :name=>'Thailand').save
      Country.new( :code=>'tp', :name=>'Timor-Leste').save
      Country.new( :code=>'tg', :name=>'Togo').save
      Country.new( :code=>'tk', :name=>'Tokelau').save
      Country.new( :code=>'to', :name=>'Tonga').save
      Country.new( :code=>'tt', :name=>'Trinidad and Tobago').save
      Country.new( :code=>'tn', :name=>'Tunisia').save
      Country.new( :code=>'tr', :name=>'Turkey').save
      Country.new( :code=>'tm', :name=>'Turkmenistan').save
      Country.new( :code=>'tc', :name=>'Turks and Caicos Islands').save
      Country.new( :code=>'tv', :name=>'Tuvalu').save
      Country.new( :code=>'ug', :name=>'Uganda').save
      Country.new( :code=>'ua', :name=>'Ukraine').save
      Country.new( :code=>'ae', :name=>'United Arab Emirates').save
      Country.new( :code=>'uk', :name=>'United Kingdom').save
      Country.new( :code=>'us', :name=>'United States of America').save
      Country.new( :code=>'vi', :name=>'United States Virgin Islands').save
      Country.new( :code=>'uy', :name=>'Uruguay').save
      Country.new( :code=>'um', :name=>'US Minor Outlying Islands').save
      Country.new( :code=>'su', :name=>'USSR').save
      Country.new( :code=>'uz', :name=>'Uzbekistan').save
      Country.new( :code=>'vu', :name=>'Vanuatu').save
      Country.new( :code=>'va', :name=>'Vatican City State').save
      Country.new( :code=>'ve', :name=>'Venezuela').save
      Country.new( :code=>'vn', :name=>'Vietnam').save
      Country.new( :code=>'wf', :name=>'Wallis and Futuna Islands').save
      Country.new( :code=>'eh', :name=>'Western Sahara').save
      Country.new( :code=>'ye', :name=>'Yemen').save
      Country.new( :code=>'yu', :name=>'Yugoslavia').save
      Country.new( :code=>'zm', :name=>'Zambia').save
      Country.new( :code=>'zw', :name=>'Zimbabwe').save
    end 

    task :users => :environment do
      puts "A criar Users!"
      user = User.new
      user.login                 = 'miguelregedor@gmail.com'
      user.password              = 'projecto128'
      user.password_confirmation = 'projecto128'
      user.name                  = 'Miguel Regedor'
      user.role                  =  User::ROOT
      user.email                 = 'miguelregedor@gmail.com'
      user.phone                 = "964472540"
      user.sex                   = "male"
      user.save
      user.activate!
      user = User.new
      user.login                 = 'jsribeiro@gmail.com'
      user.password              = 'itacapass'
      user.password_confirmation = 'itacapass'
      user.name                  = 'IDM Admin'
      user.role                  =  User::ADMIN
      user.email                 = 'jsribeiro@gmail.com'
      user.phone                 = ""
      user.sex                   = "male"
      user.save
      user.activate!
      puts "Concluido!"
    end

    task :all => [:categories, :users, :genres, :document_types, :countries, :music_genres, :subcategories]

  end
end
