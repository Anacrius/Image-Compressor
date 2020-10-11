COMPILING = \n\033[1;34m[Compiling ...]\033[0m   ┬─┬⃰͡ (ᵔᵕᵔ͜ )\n

SUCCESS = \n(☞ﾟヮﾟ)☞ \033[0;32m[SUCCESS]\033[0m ☜(ﾟヮﾟ☜)\n

FAIL = \n\033[1;31m[... Fail]\033[0m \t(╯°□°)╯ ┻━┻\n

SUPPR = \n \t(∩｀-´)⊃━☆ﾟ.*･｡ﾟ \n\n \t\t\t cleaning done

PURGED = \n \t(∩｀-´)⊃━☆ﾟ.*･｡ﾟ \n\n \t\t\t DIS IS PURGED

name = sampler

file = Main

all:
	@echo -e "$(COMPILING)"
	@ghc $(file).hs -o $(name)
	@rm $(file).hi $(file).o

clean:
	@echo -e "\nCleaning ...\n"
	@rm $(name)
	@echo -e "	$(SUPPR)\n"

.PHONY: all clean
