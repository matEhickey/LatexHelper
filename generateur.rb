require 'gtk2'
require './AideMemoire.rb'
require './selecteurDimage.rb'
require './previs.rb'
require './Lexeme.rb'
require './fenetreListe.rb'


class Generateur < Gtk::Builder
	
	@type = ""#article ou beamer
	@titre = ""
	@auteur
	@contenu
	@pileContenu
	@image
	@openFrame
	
	@previs #fenetre de previsualisation
	
  def initialize 
    super()
    
    @contenu = ""
    @pileContenu = Array.new
    
    
    self.add_from_file(__FILE__.sub(".rb",".glade"))
    
    self['window1'].set_window_position Gtk::Window::POS_CENTER
    self['window1'].signal_connect('destroy') { Gtk.main_quit }
    self['window1'].set_title("Generateur LaTex");
    
    
    # Creation d'une variable d'instance par composant glade
    self.objects.each() { |p|
    	begin
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
       rescue
       	puts "#{p} a eu un probleme lors de l'init"
       end
        
     }

     self.connect_signals{ |handler| 
        #puts handler
        method(handler)
      }
      
      #Raccourcei sauvegarder
      ag = Gtk::AccelGroup.new
			ag.connect(Gdk::Keyval::GDK_S, Gdk::Window::CONTROL_MASK,
          Gtk::ACCEL_VISIBLE) {
  				save
			}
			
			#raccourci open
			ag2 = Gtk::AccelGroup.new
			ag2.connect(Gdk::Keyval::GDK_O, Gdk::Window::CONTROL_MASK,
          Gtk::ACCEL_VISIBLE) {
          
  						fileChooser = Gtk::FileChooserDialog.new("Open File",@window1,                                Gtk::FileChooser::ACTION_OPEN,  nil, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],         [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
  						
  						fileChooser.show_all
  						
			}
			
			@window1.add_accel_group(ag)
      @window1.add_accel_group(ag2)
      
      @openFrame = false
         
      @previs = Previs.new(@pileContenu)
      
      self['window1'].show_all

      
      
      
      @beamer = false
      @openFrame = false
      @openBlock = false
  end
  
  
  def changeType(button)
  	@type = @entryType.text
  	@labelType.set_text(@type)
  	if(@type == "beamer")
      #@boutonNewFrame.show
      #@entryFrame.show
      #@labelFrame.show
      ##@buttonType.hide
      @labelSect.label = "Ajouter Block"
      #@beamer = true
      
      @labelSub.label = "Ajouter Frame"
      #@entrySubsection.hide
      #@buttonSubsection.hide
    elsif(@type == "article")
      @labelSect.label = "Ajouter Section"
      @labelSub.label = "Ajouter Subsection"
    elsif(@type == "html")
    	@labelSect.label = "Ajouter <h2>"
      @labelSub.label = "Ajouter <h3>"
  	end
  	
  end
  
  
  
  def changeTitre()
  	@titre = @entryTitle.text
  	@labelTitre.set_text @titre
  	
  end
  

  
  def addPrincipal()
  	texte = @entrySection.text
  	lexeme = Lexeme.new("principal",texte)
  	@pileContenu.push(lexeme)
  	@previs.actualise
  end
  
  def addSecondaire()
  	texte = @entrySubsection.text
  	lexeme = Lexeme.new("secondaire",texte)
  	@pileContenu.push lexeme
  	@previs.actualise
  end
  
  def addText()
  	texte = @entryTexte.text
  	@entryTexte.text = ""
  	lexeme = Lexeme.new("texte",texte)
  	@pileContenu.push lexeme
  	@previs.actualise
  end
  
  def changeAuteur
  	@auteur = @entryAuteur.text
  	@labelAuteur.set_text @auteur
  end
  
  def addImage
  	puts "AddImage"
  	if(!@image.nil?)
  		@pileContenu.push "\\includegraphics[width=#{@tailleImage.value}]{#{@image}}\\\\ \n"
  		
  	else
  		@imageChooserButton.set_label "Il faut cliquer ici pour ajouter une image"
  	end
  	@previs.actualise
  end
  
  def showAide
  	AideMemoire.new
  end
  
  def loadImage
		puts "appel a load_image"
		pipeReader,pipeWritter = IO.pipe
		@selecteurDimage = SelecteurDimage.new(pipeWritter);
		t1 = Thread.new(){
				filename = pipeReader.gets.delete!("\n")
				#puts filename = pipeReader.read
				#@imageChooserButton.set_label(filename)
				@labelImage.text = filename
				@image = filename
				#puts filename
		}
	end
	
	def newFrame()
		text = @entryFrame.text
		if(@openFrame)
			endFrame
		end
		lexeme = Lexeme.new("frame",text)
		@pileContenu.push lexeme
		@openFrame = true
		@buttonEndFrame.show
		@previs.actualise
	end
	

	
	
	
	def newListe
		FenetreListe.new(@pileContenu,@previs)
		puts "new list"
	end
  
  def genererCode()
  	#puts "---------------------------------------------"
  	chaine = ""
  	if((@entryFile.text != ""))
  		if((@type == "article")||(@type == "beamer"))
				file = File.new("#{@entryFile.text}.tex","w+")
			
			elsif(@type == "html") #end if type == latex
				file = File.new("#{@entryFile.text}.html","w+")
				
  		end
  		
  		#Algo creation du contenu et bornage
  		Lexeme.langue(@type)
  		chaine += Lexeme.init(@titre,@auteur)
  		@pileContenu.each{|lex|
  			if(lex.class.to_s == "Lexeme")
  				chaine += lex.to_s()
  			else
  				chaine += lex	
  			end
  			
  		}
  		chaine += Lexeme.finalise
  		
  		
  		
  		
  		#puts chaine
  		file.puts chaine
  		file.close
  		
  		puts "Fichier construit"  		
  		
  		
  	else
  		puts "Aucun nom de fichier"
  	end
  	
  	#puts "---------------------------------------------"
  end
  
  
  def generateOpen
  		if(@type == "article"||@type == "beamer")
				system "pdflatex #{@entryFile.text}.tex "#> /dev/null"
				system "gnome-open #{@entryFile.text}.pdf"
			elsif(@type == "html")
				system "gnome-open #{@entryFile.text}.html"
  		end
  end
  
  def save
  	file = File.new("#{@entryFile.text}.sauv","w+")

  	chaine = Marshal.dump @pileContenu
  	file.puts chaine
  	file.close
  	@labelInfo.text = "Sauvegarde effectue"
  	Thread.new(){
  					sleep(1)
  					@labelInfo.text = ""
  				}
  end
  
  def restore()
  	file = File.read("#{@entryFile.text}.sauv")
  	arrayTemp = Marshal.load(file)
  	#@pileContenu.each{|x|
  		#puts @pileContenu.length
  		#@pileContenu.delete(x)
  	#}
  	
  	while(@pileContenu.size>0)
  		@pileContenu.pop
  	end

  	
  	arrayTemp.each{|x|
  		@pileContenu.push(x)
  	}
  	
  	@previs.actualise
  end



end

Gtk.init
generateur = Generateur.new()
Gtk.main

