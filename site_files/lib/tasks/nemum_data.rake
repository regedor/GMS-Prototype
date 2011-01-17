namespace :db do
  namespace :fill do
    namespace :nemum_data do

      task :posts => :environment do
        Post.create(
          :title                   => "NEMUM lançou a nova página hoje",
          :body                    => "Já está no ar o novo site do Núcleo de Estudantes de Medicina da Universidade do Minho. O Portal apresenta novo layout, mais dinamicidade e conteúdo. Aqui poderás encontrar toda a informação sobre o teu curso.",
          :active                  => true,
          :approved_comments_count => 0,
          :published_at            => Time.now - 2.days,
          :edited_at               => nil,
          :updated_at              => nil
        )

        Post.create(
          :title                   => "Aulas de Danças de Salão",
          :body                    => "Queres aprender a dançar o Tango ou a Valsa? O NEMUM está a promover um curso de danças de salão. As aulas decorrem durante os dias úteis, das 18:30 às 20:00. O custo é de 10€ mensais.<br /><br />Inscreve-te já em nemum@ecsaude.uminho.pt e indica o dia da tua preferência.",
          :active                  => true,
          :approved_comments_count => 0,
          :published_at            => Time.now - 1.day,
          :edited_at               => nil,
          :updated_at              => nil
        )

        Post.create(
          :title                   => "Tomada de Posse",
          :body                    => "O Núcleo de Estudantes de Medicina da Universidade do Minho (NEMUM) realizará a sessão solene de tomada de posse dos seus novos órgãos sociais no próximo dia 17 de Janeiro de 2011 (segunda-feira), pelas 19h, no Anfiteatro A0.01 da Escola de Ciências da Saúde da Universidade do Minho, sito no Campus de Gualtar, em Braga.",
          :active                  => true,
          :approved_comments_count => 0,
          :published_at            => Time.now,
          :edited_at               => nil,
          :updated_at              => nil
        )
      end

      task :pages => :environment do
        Page.create(
          :title        => "A Direcção",
          :has_comments => false,
          :body         => "|Presidente|João Firmino Domingues Barbosa Machado|3ºano|\n|Vice-presidente|Teresa Mariana Faria Pinto|5ºano|\n|Tesoureira|Ana Luísa Figueiredo Pereira Pinto|5ºano|\n|Coordenadora de Projectos|Ana Luísa Carneiro Morais de Sousa|3ºano|\n|Secretária|Luísa Maria Russo Prada|2ºano|\n\nh2. Departamento da Acção Comunitária – DAC:\n\n|Coordenadores|Vera Filipa da Silva Trocado|3ºano|\n||Helena Isabel Braga Veloso|2ºano|\n||Sara Gabriela Esteves Ferreira|1ºano|\n||Sara Isabel Pires Nunes|2º ano|\n||Carla Fernandes Martins|3ºano|\n||Ana Gabriela Leite Fernandes|1º ano|\n||Cátia Andreia da Costa Oliveira|1ºano|\n||Ana de Sousa Pinto de Sottomayor|2ºano|\n\nh2. Departamento Recreativo – DR:\n\n|Coordenador|Ricardo Jorge Moreira Lopes Fernandes|4ºano|\n||Joel Ponte Monteiro|4ºano|\n||Pedro Coelho Soares Teixeira Mota|4ºano|\n\nh2. Departamento Cultural – DC:\n\n|Coordenador|Cláudia Sofia Fernandes Teixeira|3ºano|\n||Vera Lúcia dos Santos Montes|3ºano|\n||Ana Luísa Barbosa e Poças|3ºano|\n||Ana Cláudia Caldelas Pereira|3ºano|\n\nh2. Departamento Científico:\n\n|Coordenador|Andreia Raquel Barbosa Gonçalves da Silva|5ºano|\n||Célia Márcia Azevedo Soares|5ºano|\n||Sagar Dipak Silva Pratapsi|1ºano|\n||André Miguel Lopes Miranda|1ºano|\n||Anaisa Iria Guimarães da Silva|3ºano|\n||Ana Raquel Pereira Vieira de Almeida Dias|3ºano|\n\nh2. Gabinete de Apoio ao Aluno:\n\n|Coordenador|José Pedro Sousa Martins Águeda|3ºano|\n\nh2. Departamento Intercâmbios:\n\n|Coordenador|Miguel Goulão da Cunha|1ºano|\n||Bernardo Miguel Morais Pereira|2ºano|\n||Catarina Castro Vasconcelos Martins Amaral|5ºano|\n\nh2. Departamento de Marketing\n\n|Coordenador|Ana Luísa da Costa André|2ºano|\n\nh2. Departamento Informática:\n\n|Coordenador|João Francisco Mota Louro|2ºano|\n||Sara Virgínia Laureano Alves|2ºano|",
          :show_in_navigation => true
        )

        Page.create(
          :title        => "Contactos",
          :has_comments => false,
          :body         => "Núcleo de Estudantes de Medicina da Universidade do Minho\nEscola de Ciências da Saúde\nUniversidade do Minho\nCampus de Gualtar\n4710-057 BRAGA\nTelefone: 253 604 829\nEmail: nemum@ecsaude.uminho.pt",
          :show_in_navigation => true
        )

        Page.create(
          :title        => "História do NEMUM",
          :has_comments => false,
          :body         => "Criado por uma comissão instaladora constituída por sete elementos, no ano do início do curso de Medicina da Universidade do Minho, o esboço do NEMUM começou a tomar forma em Abril de 2001, movido pela necessidade de uma instituição que representasse os alunos de Medicina e pelo desejo de oferecer actividades aos estudantes e à comunidade. É seis meses depois, no dia 8 de Outubro de 2002, que o NEMUM realiza as suas primeiras eleições, embora os estatutos só tenham sido publicados em Diário da República no ano seguinte.\n\nAs principais dificuldades que este projecto encontrou, no seu início, foram a falta de financiamento e de uma estrutura física. Aliás, no que toca a instalações, o NEMUM começou por confinar-se a um armário numa sala de aulas. A entrada oficial do NEMUM na Associação Nacional de Estudantes de Medicina (ANEM) acontece em 2003, numa Assembleia Geral (AG) realizada na Foz do Arelho.\n\nEntre as primeiras actividades organizadas pelo Núcleo, destacam-se os momentos de convívio com os Globos de Ouro e a Gala Adeus SOFs (com a sua polémica aprovação em AG) e o protocolo com a Ordem dos Médicos.\n\nNos anos seguintes, estabelecem-se protocolos com diversos cursos da Universidade do Minho, iniciam-se algumas acções de promoção da saúde junto da população e publica-se o primeiro Sótão do Pensamento (2003), uma colectânea de poemas dos alunos e docentes da escola, seguido do 2º volume, três anos mais tarde.\n\nEm Janeiro de 2005, a sede do NEMUM muda-se para a zona das “pirâmides” na Universidade e, já em 2007, desloca-se para a sua morada actual, no Edifício da Escola de Ciências da Saúde. Acompanhando o aumento do número de alunos no curso, o núcleo tem diversificado as suas actividades e expandindo a sua área de actuação.\n\nDe entre as muitas pessoas que já contribuíram para o NEMUM de hoje, destacamos os Presidentes, como seus representantes, desde o primeiro ao actual:\n\n* 1.Pedro Morgado (Interno de Psiquiatria, Hospital de Braga)\n*  2.Marina Gonçalves (Interna de MGF, USF + Carandá)\n* 3.Ana Daniela Marques (Interna de Oncologia Médica, Hospital de Braga)\n* 4.Sónia Duarte\n* 5.Teresa Pinto\n* 6.Luísa Azevedo\n* 7.Firmino Machado",
          :show_in_navigation => true
        )
      end

      task :announcements => :environment do
        Announcement.create(
          :title       => "Tomada de Posse",
          :message     => "O NEMUM realiza a sessão solene de tomada de posse dos seus novos órgãos sociais no dia 17 de Janeiro de 2011.",
          :avatar      => File.open("public/images/announcements/tomada_posse.png"),
          :always_show => true,
          :created_at  => Time.now,
          :starts_at   => Time.now,
          :ends_at     => Time.now + 1.year
        )
        Announcement.create(
          :title       => "NEMUM",
          :message     => "Este é o novo portal de Núcleo de Estudantes de Medicina da Universidade do Minho, aqui encontrarás toda a informação sobre o teu curso.",
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
