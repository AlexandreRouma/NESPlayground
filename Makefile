CC=cc65
CA=ca65
LD=ld65
CFLAGS= -t nes
LDFLAGS= -t nes
ASMFLAGS= -t nes
SRC_DIR=src
BIN_DIR=bin
OUTPUT=test.nes

C_SRC = $(wildcard $(SRC_DIR)/*.c)
ASM_SRC = $(wildcard $(SRC_DIR)/*.asm)

C_ASM = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%.ca,$(C_SRC))
C_OBJ = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%.co,$(C_SRC))

ASM_OBJ = $(patsubst $(SRC_DIR)/%.asm,$(BIN_DIR)/%.ao,$(ASM_SRC))

# Build Assembly Objects
$(BIN_DIR)/%.ao: $(SRC_DIR)/%.asm
	$(CA) $^ -o $@ $(ASMFLAGS)

# Build C Objects
$(BIN_DIR)/%.co: $(BIN_DIR)/%.ca
	$(CA) $^ -o $@ $(ASMFLAGS)

# Build assembly from C source
$(BIN_DIR)/%.ca: $(SRC_DIR)/%.c
	$(CC) $^ -o $@ $(CFLAGS)

$(BIN_DIR)/$(OUTPUT): $(ASM_OBJ) $(C_OBJ) 
	$(LD) $^ -o $(BIN_DIR)/$(OUTPUT) $(LDFLAGS)
	rm $(BIN_DIR)/res.ao

clean: 
	rm $(BIN_DIR)/*