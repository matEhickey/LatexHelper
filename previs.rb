require 'gtk2'
require './Lexeme.rb'

class Previs 
	@contenu #tableau des contenu
	def initialize(contenu)
		@contenu = contenu
		
		@window = Gtk::Window.new("Previsualisation");
		@window.set_default_size(400, 200)
		@window.signal_connect('destroy') { Gtk.main_quit }
		@vbox = Gtk::VBox.new
		scrolled_window = Gtk::ScrolledWindow.new
		
		scrolled_window.set_policy(Gtk::POLICY_NEVER,Gtk::POLICY_AUTOMATIC)
		
		scrolled_window.add_with_viewport(@vbox)
		@window.add scrolled_window
		@window.show_all
	end
	
	def actualise
		@vbox.each{|contenu|
			@vbox.remove contenu
		}
		@contenu.each{|lex|
		
			if((lex.class.to_s == "Lexeme"))
				button = Gtk::Button.new(lex.value)
				button.signal_connect('clicked'){
						puts "clic"
						@contenu.delete(lex)
						actualise
				}
				if(lex.type == "section" ||lex.type == "frame")
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(50000, 00, 300))
				elsif(lex.type == "subsection"||lex.type == "block")
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(300, 00, 50000))
				elsif(lex.type == "endframe")
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(15000, 00, 100))
				elsif(lex.type == "endblock")
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(100, 00, 15000))
				else
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(40000, 40000, 40000))
				end
				@vbox.add(button)
			end
		}
		@vbox.show_all
	end


end



