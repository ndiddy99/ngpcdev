ASM = asm900.exe
AFLAGS = -Nb2 -O1 -g -l
LNK = tulink
CONV = tuconv -Fs24
TRANS = s242ngp
PAD = pad
TARGET = sample.ngp
SIZE = 524288


all: $(TARGET)

clean:
	rm *.rel
	rm *.abs
	rm *.map
	rm *.lst
	rm *.s24
	rm *.ngp
	
%.rel: %.asm
	$(ASM) $(AFLAGS) $<


sample.ngp: vect.rel work.rel main.rel print.rel init.rel graphics.rel scroll.rel player.rel
	$(LNK) sample.lcf
	$(CONV) sample.abs
	$(TRANS) sample.s24
	$(PAD) sample.ngp $(SIZE)
	
