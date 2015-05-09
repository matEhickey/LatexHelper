require 'gtk2'


class FenetreListe < Gtk::Builder
	@liste
	@contenu
	@previs
	def initialize(contenu,previs)
		super()
		@contenu = contenu
		@previs = previs
		@liste = Array.new
		self.add_from_file(__FILE__.sub(".rb",".glade"))
    
    self['window1'].set_window_position Gtk::Window::POS_CENTER
    self['window1'].signal_connect('destroy') { self['window1'].hide }
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
     @vbox = Gtk::VBox.new
     
     @scrolledwindow1.set_policy(Gtk::POLICY_NEVER,Gtk::POLICY_AUTOMATIC)
     @scrolledwindow1.add_with_viewport(@vbox)
     
     @window1.show_all
	end
	
	def add()
		@liste.push Item.new(@entry1.text,@liste,self)
		actualise
	end
	
	def actualise
		puts @liste.size
		@vbox.each{|item|
			@vbox.remove(item)
		}
		@liste.each{|item|
			@vbox.add(item)
		}
		@vbox.show_all
	end
	
	def getListe
		chaine = ""
		
		@liste.each{|item|
			chaine += item.to_s
		}
		@contenu.push Lexeme.new("liste",@liste)
		@previs.actualise
		@window1.hide
	end
	
end


class Item < Gtk::Button
	@liste
	@fenetreListe
	@value
	def initialize(label,liste,fenetreListe)
		super(label)
		@value = label
		@liste = liste
		@fenetreListe = fenetreListe
		self.signal_connect('clicked'){suppr}
	end
	
	def suppr
		@liste.delete self
		@fenetreListe.actualise
	end
	
	def to_s
		return @value
	end
	
end
