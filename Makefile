MAKEFLAGS := --jobs=$(shell nproc)

export define build_command
	cd /workspace/zmk/app;
	west build -b nice_nano_v2 -- -DSHIELD=$* -DZMK_CONFIG=/workspace/config;
	mv build/zephyr/zmk.uf2 /workspace/$@;
endef

define targets
	kyria_custom_rev2_left
	kyria_custom_rev2_right
endef


all: $(addsuffix .uf2, $(addprefix target/, $(targets)))

install: $(addprefix flash/, $(targets))

flash/%: /media/%/CURRENT.UF2 target/%.uf2
	cp target/$*.uf2 /media/$*/firmware.uf2

test:
	echo "$$build_command"

/media/%/CURRENT.UF2:
	$(error Board $* not mounted in bootloader mode)

target/%.uf2: ./config/*
	docker run --rm \
		-v $(PWD)/config:/workspace/config \
		-v $(PWD)/target:/workspace/target \
		zmk:latest sh -c "$$build_command"
clean:
	rm -f target/*
