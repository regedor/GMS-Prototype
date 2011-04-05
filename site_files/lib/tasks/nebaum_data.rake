namespace :db do
  namespace :fill do
    namespace :nebaum_data do

      task :posts => :environment do
        Post.create(
          :title                   => "NEBAUM lançou a nova página hoje",
          :body                    => "Já está no ar o novo site do Núcleo de Estudantes de Biologia Aplicada da Universidade do Minho. O Portal apresenta novo layout, mais dinamicidade e conteúdo. Aqui poderás encontrar toda a informação sobre o teu curso.",
          :active                  => true,
          :approved_comments_count => 0,
          :published_at            => Time.now,
          :edited_at               => nil,
          :updated_at              => nil
        )
      end

      task :pages => :environment do
        Page.create(
          :title        => "Quem Somos",
          :has_comments => false,
          :body         => "O Núcleo de Estudantes de Biologia Aplicada da Universidade do Minho é um projecto ambicioso que procura dar respostas a aqueles que, usufruindo da existência do mesmo, querem promover a sua formação cívica, cultural e científica em prol de um conhecimento mais vasto e profundo no domínio da Biologia. Pretendemos ainda promover a cooperação e interacção dos seus associados assim como fomentar o gosto, o interesse e a busca pela vasta área da Biologia.\n\nSão objectivos do NEBAUM:\n\n#a) Defender os interesses dos estudantes inscritos na Licenciatura em Biologia Aplicada da Universidade do Minho;\n#b) Promover a formação cívica, cultural e científica dos seus associados;\n#c) Cooperar com todos os organismos estudantis, nacionais ou estrangeiros, cujos princípios não contrariem os aqui definidos;\n#d) Fomentar as relações de cooperação e amizade com os antigos estudantes de Biologia Aplicada da Universidade do Minho;\n#e) Promover e colaborar em acções de índole cultural e recreativa relacionadas com a vida académica;\n#f) Complementar a formação académica dos alunos e apoiar os novos alunos na sua integração no ensino superior;\n#g) Representar os estudantes inscritos na Licenciatura em Biologia Aplicada da Universidade do Minho em todas as ocasiões que tal se afigure necessário.",
          :show_in_navigation => true
        )

        Page.create(
          :title        => "A Direcção",
          :has_comments => false,
          :body         => "|Presidente|Rita Trindade|\n|Vice-presidente|Susana Sousa|\n|Vogal|Frederico Machado|\n|Tesoureira|Filipa Gonçalves|\n|Secretária|Amanda de Sousa|\n|\\2{background: #F8DA00; color: #333}.Departamento Cultural|\n|Director|Eduardo Gomes|\n|Adjunta|Fabiana Gomes|\n|Adjunto|Jorge Correia|\n|\\2{background: #F8DA00; color: #333}.Departamento de Divulgação|\n|Directora|Diana Lobo|\n|Adjunto|Adrien Machado|\n|Adjunto|Bruno Silva|\n|\\2{background: #F8DA00; color: #333}.Departamento de Apoio ao Aluno|\n|Directora|Rute Chitas|\n|Adjunto|Eduardo Campos|\n|\\2{background: #F8DA00; color: #333}.Departamento Comercial|\n|Directora|Ana Patrícia Ribeiro|\n|Adjunta|Ana Margarida Cunha|",
          :show_in_navigation => true
        )

        Page.create(
          :title        => "Contactos",
          :has_comments => false,
          :body         => "Núcleo de Estudantes de Biologia Aplicada da Universidade do Minho\nEscola de Ciências\nUniversidade do Minho\nCampus de Gualtar\n4710-057 BRAGA\nTelefone: 918228662\nEmail: nebaum@gmail.com",
          :show_in_navigation => true
        )
      end

      task :announcements => :environment do
        Announcement.create(
          :title       => "NEBAUM",
          :message     => "Este é o novo portal do Núcleo de Estudantes de Biologia Aplicada da Universidade do Minho, aqui encontrarás toda a informação sobre o teu curso.",
          :avatar      => File.open("public/images/announcements/studying.png"),
          :always_show => true,
          :created_at  => Time.now,
          :starts_at   => Time.now,
          :ends_at     => Time.now + 1.year
        )
      end

      task :all => [:pages, :posts, :announcements]

    end
  end
end
