require 'gtk2'
require './AideMemoire.rb'
require './selecteurDimage.rb'
require './previs.rb'
require './Lexeme.rb'



class Generateur < Gtk::Builder
	
	@type = ""
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
      @buttonEndFrame.hide
      @boutonNewFrame.hide
      @entryFrame.hide
      @labelFrame.hide
      
      
      
      @beamer = false
      @openFrame = false
      @openBlock = false
  end
  
  
  def changeType(button)
  	@type = @entryType.text
  	@labelType.set_text(@type)
  	if(@type == "beamer")
      @boutonNewFrame.show
      @entryFrame.show
      @labelFrame.show
      @buttonType.hide
      @labelSect.label = "Ajouter block"
      @beamer = true
      
      @labelSub.hide
      @entrySubsection.hide
      @buttonSubsection.hide
      
    else
    	@buttonEndFrame.hide
      @boutonNewFrame.hide
      @entryFrame.hide
      @labelFrame.hide
  	end
  	
  end
  
  
  
  def changeTitre()
  	@titre = @entryTitle.text
  	@labelTitre.set_text @titre
  	
  end
  

  
  def addSection()
  	texte = @entrySection.text
  	if(!@beamer)
  		lexeme = Lexeme.new("section",texte)
  		@pileContenu.push(lexeme)
  	else
  		if(@openBlock)
  			endBlock
  		end
  			lexeme = Lexeme.new("block",texte)
  			@pileContenu.push lexeme
  			@openBlock=true
  	end
  	@previs.actualise
  end
  
  def addSubsection()
  	texte = @entrySubsection.text
  	lexeme = Lexeme.new("subsection",texte)
  	@pileContenu.push lexeme
  	@previs.actualise
  end
  
  def addText()
  	texte = @entryTexte.text
  	@entryTexte.text = ""
  	lexeme = Lexeme.new("text",texte)
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
	
	def endFrame()
		if(@openFrame)
			if(@openBlock)
				endBlock
			end
			lexeme = Lexeme.new("endframe","endframe")
			@pileContenu.push lexeme
			
		end
		@openFrame = false
		@buttonEndFrame.hide
		@previs.actualise
	end
	
	def endBlock
		if(@openBlock)
			lexeme = Lexeme.new("endblock","endblock")
			@pileContenu.push lexeme
			@openBlock = false
		end
		@previs.actualise
	end
  
  def genererCode()
  	#puts "---------------------------------------------"
  	chaine = ""
  	if((@entryFile.text != ""))
  	
  		file = File.new("#{@entryFile.text}.tex","w+")
  	
  		chaine += "\\documentclass[12pt,a4paper,twoside]{#{@type}}\n"
  		chaine += "\\usepackage[T1]{fontenc}\n"
  		chaine += "\\usepackage[utf8]{inputenc}\n"
  		chaine += "\\usepackage[francais]{babel}\n"
  		chaine += "\\usepackage{color}\n"
  		chaine += "\\usepackage{graphicx}\n"
  		if(@beamer)
				chaine += "\\setbeamertemplate{blocks}[rounded][shadow=true]\n"
				chaine += "\\setbeamercolor{block title}{fg=black,bg=blue}\n"
				chaine += "\\setbeamertemplate{navigation symbols}{ \\insertslidenavigationsymbol}"
			end
  		chaine += "\\begin{document}\n"
  		chaine += "\\author{#{@auteur}}\\\\\n"
  		chaine += "\\title{#{@titre}}\n"
  		chaine += "\\maketitle\n"
  		#chaine += "\\tableofcontents\n"
  		if(@openFrame)
  			endFrame()
  		end
  		@pileContenu.each{|lex|
  			if(lex.class.to_s == "Lexeme")
  				chaine += lex.to_s
  			else
  				chaine += lex	
  			end
  			
  		}
  		
  		
  		
  		
  		chaine += "\\end{document}\n"
  		#puts chaine
  		file.puts chaine
  		file.close
  		
  		puts "Fichier construit"  		
  		
  		
  		#system "pdflatex #{@entryFile.text}.tex > /dev/null"
  		#system "gnome-open #{@entryFile.text}.pdf"
  		
  	else
  		puts "Aucun nom de fichier"
  	end
  	
  	#puts "---------------------------------------------"
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

