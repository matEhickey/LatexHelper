class Lexeme
	@type	#pour l'instant 3 types : principal,secondaire,texte, d'autres pourront s'ajouter
	@value
	@@openFrame = false
	@@openBlock = false
	@@langue
	
	attr_reader :type, :value
	def initialize(type,value)
		@type = type
		@value = value
	end
	
	def Lexeme.langue(langue)
		@@langue = langue
	end
	
	def Lexeme.init(titre,auteur)
		chaine = ""
		if((@@langue == "beamer")||(@@langue == "article"))
				chaine += "\\documentclass[12pt,a4paper,twoside]{#{@@langue}}\n"
				chaine += "\\usepackage[T1]{fontenc}\n"
				chaine += "\\usepackage[utf8]{inputenc}\n"
				chaine += "\\usepackage[francais]{babel}\n"
				chaine += "\\usepackage{color}\n"
				chaine += "\\usepackage{graphicx}\n"
				if(@@langue == "beamer")
					chaine += "\\setbeamertemplate{blocks}[rounded][shadow=true]\n"
					chaine += "\\setbeamercolor{block title}{fg=black,bg=blue}\n"
					chaine += "\\setbeamertemplate{navigation symbols}{ \\insertslidenavigationsymbol}\n"
				end
				chaine += "\\begin{document}\n"
				chaine += "\\title{#{titre}}\n"
				chaine += "\\author{#{auteur}}\n"
				chaine += "\\maketitle\n"
				#chaine += "\\tableofcontents\n"
		elsif(@@langue == "html")
				chaine += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
				chaine += "<html>\n"
				chaine += "<head><title>#{titre}</title></head>\n"
		end
		return chaine
	end
	
	def Lexeme.finalise
		chaine = ""
		if(@@langue == "beamer")
			if(@@openBlock)
				chaine += "\\end{block}\n"
				@@openBlock = false
			end
			if(@@openFrame)
				chaine += "\\end{frame}\n"
				@@openBlock = false
			end
			chaine += "\\end{document}\n"
		elsif(@@langue == "article")
			chaine += "\\end{document}\n"
		elsif(@@langue == "html")
			chaine += "</html>"
		end
		return chaine
	end
	
	def to_s()
		chaine = ""
		if(@@langue == "article")
			if(@type == "principal")#1
				chaine = "\\section{#{@value}}\n"
			elsif(@type == "secondaire")#2
				chaine = "\\subsection{#{@value}}\n"
			elsif(@type == "texte")#3
				chaine = "#{@value}\\\\\n"

			#elsif(@type == "endframe")
				#chaine = "\\end{frame}\n"
			#elsif(@type == "endblock")
				#chaine = "\\end{block}\n"
			end
			
		elsif(@@langue == "beamer")
		
		
			if(@type == "principal")#1
				if(@@openBlock)
					chaine += "\\end{block}\n"
					@@openBlock = false
				end
				if(@@openFrame)
					chaine += "\\end{frame}\n"
				end
				chaine += "\\begin{frame}\n\\frametitle{#{@value}}\n"#1
				@@openFrame = true
				
				
				
				
				
			elsif(@type == "secondaire")#2
				if(@@openBlock)
					chaine += "\\end{block}"
				end
				chaine += "\\begin{block}{#{@value}}\n"
				@@openBlock = true
				
				
				
			elsif(@type == "texte")#3
				chaine = "#{@value}\\\\\n"
			end
			
			
		elsif(@@langue == "html")
			if(@type == "principal")#1
				chaine += "<h2>#{@value}</h2>\n"
			elsif(@type == "secondaire")#2
				chaine += "<h3>#{@value}</h3>\n"
			elsif(@type == "texte")#3
				chaine += "<p>#{@value}</p>\n"
			end
		end
		
		
		#puts chaine
		return chaine
	end
	
	
end
