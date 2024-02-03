	device zxspectrum48

	org $0000

beginfile


start_0:					  ; CODE XREF: ROM:00A2p
						  ; ROM:0193p ROM:0209p
						  ; ROM:020Dp ROM:0265p
						  ; ROM:0308p ROM:035Dp
						  ; ROM:0387p ROM:03CEp
		ld	sp, 0C3EEh		  ; start
		ld	a, 11h
		jp	start_3B
; ---------------------------------------------------------------------------

tape_save_byte_8:				  ; CODE XREF: ROM:save_to_tape_1A5p
						  ; ROM:01ACp ROM:01AEp
						  ; ROM:01B0p ROM:01B2p
						  ; ROM:01B4p ROM:01B6p
		jp	tape_save_byte_routine_100 ; Tape_save_byte
; ---------------------------------------------------------------------------

monitor_5_view_from_XXXX_B:			  ; DATA XREF: ROM:00F8o
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		jp	monitor_2_view_from_HL_7D
; ---------------------------------------------------------------------------

keyboard_read_byte_A_print_loop_10:		  ; CODE XREF: ROM:0031p
						  ; ROM:0033p ROM:0073p
						  ; ROM:0385p ROM:03D7p
		push	de			  ; тоесть натыкать руками 2 цифры
		xor	a
		ld	d, a
		rst	20h			  ; keyboard read A loop
		rlca
		jp	keyboard_read_byte_low_nible_print_47
; ---------------------------------------------------------------------------

time_delay_18:					  ; CODE XREF: ROM:keyboard_read_A_loop_20p
						  ; ROM:0075p ROM:0088p
						  ; ROM:009Ap ROM:01FCp
		push	hl			  ; TIME DELAY
		push	af
		ld	hl, 6650h		  ; время сколько будем	висеть
		jp	time_delay_hl_56
; ---------------------------------------------------------------------------

keyboard_read_A_loop_20:			  ; CODE XREF: ROM:0013p
						  ; ROM:003Fp ROM:004Fp
						  ; ROM:monitor_2_view_from_HL_7Dp
						  ; ROM:00BDp ROM:03E3p
						  ; ROM:03E8p ROM:03EFp
						  ; ROM:03F4p
		rst	18h			  ; keyboard read A loop
		jp	keyboard_read_5F
; ---------------------------------------------------------------------------
		nop

monitor_6_run_C000_25:				  ; DATA XREF: ROM:00F9o
		jp	ram_start_C000
; ---------------------------------------------------------------------------

print_HL_A_28:					  ; CODE XREF: ROM:0072p
						  ; ROM:007Fp ROM:0087p
						  ; ROM:0099p ROM:00BCp
						  ; ROM:018Ep ROM:01FBp
						  ; ROM:0384p ROM:03CDp
						  ; ROM:03D6p ROM:03E2p
						  ; ROM:03E7p ROM:03EEp
						  ; ROM:03F3p
		ld	(video_ram_9000), a	  ; print HL A on screen
		ld	(video_ram_9001), hl
		ret
; ---------------------------------------------------------------------------
		nop				  ; больше мусора

keyboard_read_word_DE_30:			  ; CODE XREF: ROM:monitor_5_view_from_XXXX_Bp
						  ; ROM:monitor_7_run_XXXX__84p
						  ; ROM:write_from_XXXX_91p
						  ; ROM:0179p ROM:017Cp
						  ; ROM:019Ep ROM:01A1p
						  ; ROM:01C6p
						  ; ROM:program_200_25F_input_224p
						  ; ROM:0226p ROM:022Fp
						  ; ROM:program_2E5_super_code_address_correctionp
						  ; ROM:02EEp ROM:02F6p
						  ; ROM:program_309_addres_replacep
						  ; ROM:030Bp ROM:0310p
						  ; ROM:0315p
						  ; ROM:program_35E_insert_bytep
						  ; ROM:0365p ...
		push	af			  ; Keyboard read word DE
		rst	10h			  ; keyboard read byte A and print loop
		ld	d, a
		rst	10h			  ; keyboard read byte A and print loop
		ld	e, a			  ; ввод 4 ниблов использую только 2 индикатора...
		pop	af
		ret
; ---------------------------------------------------------------------------
		nop				  ; суровый челябинский	1Hz INT

INT_clock_38:					  ; CODE XREF: ROM:03FAp
						  ; ROM:03FBp ROM:03FCp
						  ; ROM:03FDp ROM:03FEp
						  ; ROM:03FFp
		jp	int_clock_routine_C1	  ; КРУТА!!!
						  ; прерывание в советских компьютерах...
						  ; ...с какой оно должно быть частотой...
						  ; видимо никто не сказал....
; ---------------------------------------------------------------------------

start_3B:					  ; CODE XREF: ROM:0005j
		ei
		ld	(video_ram_9000), a
		rst	20h			  ; keyboard read A loop
		add	a, monitor_jump_table_F3  ; jump table же! ВНЕЗАПНО
		ld	h, 0
		ld	l, a
		ld	l, (hl)
		jp	(hl)			  ; F3+0D = 00 start
						  ; F3+0E = 01 xor c3 :	ld a,11	: start
						  ; F3+0F = 02 jp 113E - fail (возможно	от туда	читаетсо FF и тогда все	ок)
; ---------------------------------------------------------------------------

keyboard_read_byte_low_nible_print_47:		  ; CODE XREF: ROM:0015j
		rlca
		rlca
		rlca
		or	d			  ; при	этом там 0...
		ld	d, a
		ld	(video_ram_9000), a
		rst	20h			  ; keyboard read A loop
		or	d			  ; ввод младшего нибла
		ld	(video_ram_9000), a
		pop	de
		ret
; ---------------------------------------------------------------------------

time_delay_hl_56:				  ; CODE XREF: ROM:001Dj
						  ; ROM:0059j
		dec	hl
		ld	a, l
		or	h
		jp	nz, time_delay_hl_56
		pop	af
		pop	hl
		ret
; ---------------------------------------------------------------------------

keyboard_read_5F:				  ; CODE XREF: ROM:0021j
						  ; ROM:0063j
		in	a, (0A0h)		  ; порт клавиатуры же!
		add	a, 0			  ; and	a вшколенеучили?
		jp	z, keyboard_read_5F
		cp	80h ; 'А'                 ; проверка клавиши ШАГ НАЗАД
		jp	z, key_step_back_pressed_6E
		and	0Fh
		ret
; ---------------------------------------------------------------------------

key_step_back_pressed_6E:			  ; CODE XREF: ROM:0068j
		dec	hl
		dec	sp
		dec	sp			  ; ШО_ПРОИСХОДИТ? о_О

keyboard_write_byte_to_1HL1_71:			  ; CODE XREF: ROM:0077j
						  ; ROM:008Dj ROM:0093j
		xor	a
		rst	28h			  ; print HL A on screen
		rst	10h			  ; keyboard read byte A and print loop
		ld	(hl), a
		rst	18h			  ; TIME DELAY
		inc	hl
		jp	keyboard_write_byte_to_1HL1_71
; ---------------------------------------------------------------------------

monitor_2_view_from_C000_7A:			  ; DATA XREF: ROM:00F5o
		ld	hl, ram_start_C000

monitor_2_view_from_HL_7D:			  ; CODE XREF: ROM:000Dj
						  ; ROM:0081j ROM:03AFj
		rst	20h			  ; keyboard read A loop
		ld	a, (hl)
		rst	28h			  ; print HL A on screen
		inc	hl
		jp	monitor_2_view_from_HL_7D
; ---------------------------------------------------------------------------

monitor_7_run_XXXX__84:				  ; DATA XREF: ROM:00FAo
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		xor	a
		rst	28h			  ; print HL A on screen
		rst	18h			  ; TIME DELAY
		jp	(hl)
; ---------------------------------------------------------------------------

monitor_1_write_from_C000_8A:			  ; DATA XREF: ROM:00F4o
		ld	hl, ram_start_C000
		jp	keyboard_write_byte_to_1HL1_71
; ---------------------------------------------------------------------------

monitor_C_time_set_90:				  ; DATA XREF: ROM:00FFo
		di

write_from_XXXX_91:				  ; DATA XREF: ROM:monitor_jump_table_F3o
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		jp	keyboard_write_byte_to_1HL1_71
; ---------------------------------------------------------------------------

monitor_3_indicator_test_96:			  ; DATA XREF: ROM:00F6o
		xor	a

indicator_test_97:				  ; CODE XREF: ROM:009Fj
		ld	h, a
		ld	l, a
		rst	28h			  ; print HL A on screen
		rst	18h			  ; TIME DELAY
		add	a, 11h
		cp	10h
		jp	nz, indicator_test_97
		rst	0			  ; start

monitor_4_ram_test_A3:				  ; DATA XREF: ROM:00F7o
		ld	hl, ram_start_C000

ram_test_A6:					  ; CODE XREF: ROM:00B8j
						  ; ROM:00BEj
		xor	a
		ld	(hl), a
		ld	a, (hl)
		or	a
		jp	nz, ram_read_error_BB
		dec	a
		ld	(hl), a
		ld	a, (hl)
		inc	a
		jp	nz, ram_read_error_BB
		inc	hl
		ld	a, h
		and	4
		jp	z, ram_test_A6

ram_read_error_BB:				  ; CODE XREF: ROM:00AAj
						  ; ROM:00B1j
		ld	a, (hl)
		rst	28h			  ; print HL A on screen
		rst	20h			  ; keyboard read A loop
		jp	ram_test_A6		  ; а для inc hl не нашлось места?
						  ; чтоб найти больше чем 1 байт битой памяти...
; ---------------------------------------------------------------------------

int_clock_routine_C1:				  ; CODE XREF: ROM:INT_clock_38j
		di
		push	af
		push	bc
		push	de
		push	hl
		ld	hl, int_clock_data
		ld	de, var_time_byte_C3FD	  ; C3FD
						  ; C3FE
						  ; C3FF
						  ; тут	видимо переменные для часиков
						  ; занимают драгоценную память
						  ; (с точки зрения 1к машины)
		ld	b, 3

int_clock_CE:					  ; CODE XREF: ROM:00DBj
		ld	a, (de)
		inc	a
		daa
		ld	(de), a
		cp	(hl)
		jp	nz, int_clock_DE
		xor	a
		ld	(de), a
		inc	hl
		inc	de
		dec	b
		jp	nz, int_clock_CE

int_clock_DE:					  ; CODE XREF: ROM:00D3j
		pop	hl
		pop	de
		pop	bc
		pop	af
		ei
		ret				  ; Ну и КАК? можно воспользоваться этой байдой?
						  ; Свой код своим кодом не прервешь....
						  ; советские компьютеростроители такие	советские...
; ---------------------------------------------------------------------------
int_clock_data:	db 60h				  ; DATA XREF: ROM:00C6o
		db 60h
		db 24h
; ---------------------------------------------------------------------------

monitor_9_save_to_tape_E7:			  ; DATA XREF: ROM:00FCo
		jp	save_to_tape_from_XXXX_to_XXXX_19A
; ---------------------------------------------------------------------------

monitor_A_load_from_tape_EA:			  ; DATA XREF: ROM:00FDo
		jp	load_from_tape_XXXX_1C2
; ---------------------------------------------------------------------------

monitor_8_cheksum_ED:				  ; DATA XREF: ROM:00FBo
		jp	cheksum_from_XXXX_to_XXXX_175
; ---------------------------------------------------------------------------

monitor_B_time_F0:				  ; DATA XREF: ROM:00FEo
		jp	time_1F5
; ---------------------------------------------------------------------------
monitor_jump_table_F3:db write_from_XXXX_91	  ; DATA XREF: ROM:0040o
						  ; key	10 (оноже 0)
		db monitor_1_write_from_C000_8A	  ; key	01
		db monitor_2_view_from_C000_7A	  ; key	02
		db monitor_3_indicator_test_96	  ; key	03
		db monitor_4_ram_test_A3	  ; key	04
		db monitor_5_view_from_XXXX_B	  ; key	05
		db monitor_6_run_C000_25	  ; key	06
		db monitor_7_run_XXXX__84	  ; key	07
		db monitor_8_cheksum_ED		  ; key	08
		db monitor_9_save_to_tape_E7	  ; key	09
		db monitor_A_load_from_tape_EA	  ; key	0A
		db monitor_B_time_F0		  ; key	0B
		db monitor_C_time_set_90	  ; key	0C
; ---------------------------------------------------------------------------

tape_save_byte_routine_100:			  ; CODE XREF: ROM:tape_save_byte_8j
		push	bc
		push	de
		push	af
		ld	d, a
		ld	c, 8

tape_save_byte_106:				  ; CODE XREF: ROM:011Aj
		ld	a, d
		rlca
		ld	d, a
		ld	a, 1
		xor	d
		out	(0A1h),	a		  ; порт магнитофона
						  ; хм.. а написано B0
		call	tape_save_byte_time_delay_121
		ld	a, 0
		xor	d
		out	(0A1h),	a
		call	tape_save_byte_time_delay_121
		dec	c
		jp	nz, tape_save_byte_106
		pop	af
		pop	de
		pop	bc
		ret
; ---------------------------------------------------------------------------

tape_save_byte_time_delay_121:			  ; CODE XREF: ROM:010Ep
						  ; ROM:0116p
		ld	b, 1Eh

tape_save_byte_time_delay_123:			  ; CODE XREF: ROM:0124j
		dec	b
		jp	nz, tape_save_byte_time_delay_123
		ret
; ---------------------------------------------------------------------------

load_from_tape_128:				  ; CODE XREF: ROM:01C9p
						  ; ROM:01F0p
		push	bc
		push	de
		ld	c, 0
		ld	d, a
		in	a, (0A1h)		  ; Порт магнитофона
		ld	e, a

load_from_tape_130:				  ; CODE XREF: ROM:0159j
						  ; ROM:0164j
		ld	a, c
		and	7Fh ; ''
		rlca
		ld	c, a

load_from_tape_135:				  ; CODE XREF: ROM:0138j
		in	a, (0A1h)		  ; снова порт магнитофона
		cp	e
		jp	z, load_from_tape_135
		and	1
		or	c
		ld	c, a
		call	load_from_tape_16E
		in	a, (0A1h)		  ; магнитофона
		ld	e, a
		ld	a, d
		or	a
		jp	p, load_from_tape_163
		ld	a, c
		cp	0E6h ; 'ц'                ; синхробайт
		jp	nz, load_from_tape_157
		xor	a
		ld	(var_tape_byte_C3FC), a
		jp	load_from_tape_161
; ---------------------------------------------------------------------------

load_from_tape_157:				  ; CODE XREF: ROM:014Dj
		cp	19h
		jp	nz, load_from_tape_130
		ld	a, 0FFh
		ld	(var_tape_byte_C3FC), a

load_from_tape_161:				  ; CODE XREF: ROM:0154j
		ld	d, 9

load_from_tape_163:				  ; CODE XREF: ROM:0147j
		dec	d
		jp	nz, load_from_tape_130
		ld	a, (var_tape_byte_C3FC)
		xor	c
		pop	de
		pop	bc
		ret
; ---------------------------------------------------------------------------

load_from_tape_16E:				  ; CODE XREF: ROM:013Fp
		ld	b, 2Dh ; '-'

load_from_tape_170:				  ; CODE XREF: ROM:0171j
		dec	b
		jp	nz, load_from_tape_170
		ret
; ---------------------------------------------------------------------------

cheksum_from_XXXX_to_XXXX_175:			  ; CODE XREF: ROM:monitor_8_cheksum_EDj
		push	bc
		push	de
		push	hl
		push	af
		rst	30h			  ; Keyboard read word DE
		ld	b, d
		ld	c, e
		rst	30h			  ; Keyboard read word DE

cheksum_17D:					  ; CODE XREF: ROM:01BFj
						  ; ROM:01EBj
		ld	l, 0
		ld	h, l

cheksum_180:					  ; CODE XREF: ROM:018Bj
		ld	a, (bc)
		push	de
		ld	e, a
		ld	d, 0
		add	hl, de
		pop	de
		call	cp_BC_DE_194
		inc	bc
		jp	nz, cheksum_180
		rst	28h			  ; print HL A on screen
		pop	af			  ; видимо вывод самой контроольной суммы
		pop	hl
		pop	de
		pop	bc
		rst	0			  ; start

cp_BC_DE_194:					  ; CODE XREF: ROM:0187p
						  ; ROM:01B7p ROM:01E3p
						  ; ROM:0210p ROM:021Bp
		ld	a, d
		cp	b
		ret	nz
		ld	a, e
		cp	c
		ret
; ---------------------------------------------------------------------------

save_to_tape_from_XXXX_to_XXXX_19A:		  ; CODE XREF: ROM:monitor_9_save_to_tape_E7j
		push	bc
		push	de
		push	hl
		push	af
		rst	30h			  ; Keyboard read word DE
		ld	b, d
		ld	c, e
		rst	30h			  ; Keyboard read word DE
		push	bc
		xor	a			  ; нули
		ld	l, a			  ; длина пилотона 256

save_to_tape_1A5:				  ; CODE XREF: ROM:01A7j
		rst	8			  ; Tape_save_byte
		inc	l
		jp	nz, save_to_tape_1A5
		ld	a, 0E6h	; 'ц'             ; тот самый синхробайт
		rst	8			  ; Tape_save_byte
		ld	a, b			  ; длина ширина водоизмещение
		rst	8			  ; Tape_save_byte
		ld	a, c
		rst	8			  ; Tape_save_byte
		ld	a, d
		rst	8			  ; Tape_save_byte
		ld	a, e
		rst	8			  ; Tape_save_byte

save_to_tape_1B5:				  ; CODE XREF: ROM:01BBj
		ld	a, (bc)
		rst	8			  ; Tape_save_byte
		call	cp_BC_DE_194
		inc	bc
		jp	nz, save_to_tape_1B5
		pop	bc
		jp	cheksum_17D
; ---------------------------------------------------------------------------

load_from_tape_XXXX_1C2:			  ; CODE XREF: ROM:monitor_A_load_from_tape_EAj
		push	bc
		push	de
		push	hl
		push	af
		rst	30h			  ; Keyboard read word DE
		ld	a, 0FFh
		call	load_from_tape_128
		ld	h, a

load_from_tape_1CD:
		call	load_from_tape_1EE
		ld	l, a
		add	hl, de
		ld	b, h
		ld	c, l
		push	bc
		call	load_from_tape_1EE
		ld	h, a
		call	load_from_tape_1EE
		ld	l, a
		add	hl, de
		ex	de, hl

load_from_tape_1DF:				  ; CODE XREF: ROM:01E7j
		call	load_from_tape_1EE
		ld	(bc), a
		call	cp_BC_DE_194
		inc	bc
		jp	nz, load_from_tape_1DF
		pop	bc
		jp	cheksum_17D
; ---------------------------------------------------------------------------

load_from_tape_1EE:				  ; CODE XREF: ROM:load_from_tape_1CDp
						  ; ROM:01D5p ROM:01D9p
						  ; ROM:load_from_tape_1DFp
		ld	a, 8
		call	load_from_tape_128
		ret
; ---------------------------------------------------------------------------
		nop

time_1F5:					  ; CODE XREF: ROM:monitor_B_time_F0j
						  ; ROM:01FDj
		ld	hl, (var_time_word_C3FE)
		ld	a, (var_time_byte_C3FD)
		rst	28h			  ; print HL A on screen
		rst	18h			  ; TIME DELAY
		jp	time_1F5		  ; включили часики и зависли
; ---------------------------------------------------------------------------

program_200_copy_memory_block:			  ; Программа копирования данных
		call	program_200_25F_input_224 ; xxxx - адрес начала	данных
						  ; хххх - адрес конца данных
						  ; хххх - адрес куда копировать
						  ;
						  ; и как раньше люди жили без ldir-а? :)
		jp	c, program_200_copy_20A
		call	program_200_copy_20E
		rst	0			  ; start

program_200_copy_20A:				  ; CODE XREF: ROM:0203j
		call	program_200_copy_219
		rst	0			  ; start

program_200_copy_20E:				  ; CODE XREF: ROM:0206p
						  ; ROM:0215j ROM:036Fp
		ld	a, (de)
		ld	(hl), a
		call	cp_BC_DE_194
		dec	de
		dec	hl
		jp	nz, program_200_copy_20E
		ret
; ---------------------------------------------------------------------------

program_200_copy_219:				  ; CODE XREF: ROM:program_200_copy_20Ap
						  ; ROM:0220j ROM:039Cp
		ld	a, (bc)
		ld	(hl), a
		call	cp_BC_DE_194
		inc	bc
		inc	hl
		jp	nz, program_200_copy_219
		ret
; ---------------------------------------------------------------------------

program_200_25F_input_224:			  ; CODE XREF: ROM:program_200_copy_memory_blockp
						  ; ROM:Program_25F_Code_address_correctionp
		rst	30h			  ; Keyboard read word DE
		push	de
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F2), hl
		pop	hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F0), hl
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F4), hl
		ld	a, l
		sub	e
		ld	l, a
		ld	a, h
		sbc	a, d
		ld	h, a
		ld	(var_program_200_25F_2E5_35E_388_word_C3F8), hl
		ld	c, l
		ld	b, h
		ld	hl, (var_program_200_25F_2E5_309_35E_388_word_C3F2)
		push	hl
		add	hl, bc
		ld	(var_program_200_25F_2E5_35E_388_word_C3F6), hl
		ld	hl, (var_program_200_25F_2E5_309_35E_388_word_C3F0)
		ld	c, l
		ld	b, h
		pop	de
		ld	hl, (var_program_200_25F_2E5_35E_388_word_C3F4)
		ld	a, l
		sub	c
		ld	a, h
		sbc	a, b
		ret	c
		ld	hl, (var_program_200_25F_2E5_35E_388_word_C3F6)
		ret
; ---------------------------------------------------------------------------

cp_HL_DE_259:					  ; CODE XREF: ROM:02B1p
						  ; ROM:0334p ROM:0356p
		ld	a, h
		cp	d
		ret	nz
		ld	a, l
		cp	e
		ret
; ---------------------------------------------------------------------------

Program_25F_Code_address_correction:		  ; xxxx - начальный адрес исходной программы
		call	program_200_25F_input_224 ; хххх - конечный адрес исходной программы
						  ; хххх - адрес коректируемой программы
		call	program_25F_correction_266
		rst	0			  ; start

program_25F_correction_266:			  ; CODE XREF: ROM:0262p
						  ; ROM:0305p ROM:037Fp
						  ; ROM:03ABp
		ld	hl, (var_program_200_25F_2E5_35E_388_word_C3F4)

program_25F_269:				  ; CODE XREF: ROM:02B5j
		ld	d, (hl)
		push	hl
		call	program_25F_call_jp_opcode_detector_2B9
		ld	h, b
		ex	(sp), hl
		ld	a, b
		cp	3
		jp	nz, program_25F_2A5
		inc	hl
		ld	c, (hl)
		inc	hl
		ld	b, (hl)
		dec	hl
		push	hl
		ld	hl, (var_program_200_25F_2E5_309_35E_388_word_C3F0)
		ld	a, c
		sub	l
		ld	a, b
		sbc	a, h
		jp	c, program_25F_2A3
		ld	hl, (var_program_200_25F_2E5_309_35E_388_word_C3F2)
		ld	a, l
		sub	c
		ld	a, h
		sbc	a, b
		jp	c, program_25F_2A3
		ld	hl, (var_program_200_25F_2E5_35E_388_word_C3F8)
		ld	a, l
		add	a, c
		ld	e, a
		ld	a, h
		adc	a, b
		ld	d, a
		pop	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
		inc	hl
		inc	sp
		inc	sp
		jp	program_25F_2AB
; ---------------------------------------------------------------------------

program_25F_2A3:				  ; CODE XREF: ROM:0283j
						  ; ROM:028Dj
		pop	hl
		dec	hl

program_25F_2A5:				  ; CODE XREF: ROM:0273j
		pop	bc

program_25F_2A6:				  ; CODE XREF: ROM:02A8j
		inc	hl
		dec	b
		jp	nz, program_25F_2A6

program_25F_2AB:				  ; CODE XREF: ROM:02A0j
		ld	e, l
		ld	d, h
		ld	hl, (var_program_200_25F_2E5_35E_388_word_C3F6)
		inc	hl
		call	cp_HL_DE_259
		ex	de, hl
		jp	nz, program_25F_269
		ret
; ---------------------------------------------------------------------------

program_25F_call_jp_opcode_detector_2B9:	  ; CODE XREF: ROM:026Bp
						  ; ROM:0320p
		ld	bc, 306h
		ld	hl, program_25F_opcodes_table_2D3 ; rst	38

program_25F_detector_2BF:			  ; CODE XREF: ROM:02C6j
						  ; ROM:02CFj
		ld	a, d
		and	(hl)			  ; and	FF C7
		inc	hl
		cp	(hl)			  ; call call nz
		ret	z
		inc	hl
		dec	c
		jp	nz, program_25F_detector_2BF
		ld	c, 3
		dec	b
		ld	a, b
		cp	1
		jp	nz, program_25F_detector_2BF
		ret
; ---------------------------------------------------------------------------
program_25F_opcodes_table_2D3:db 0FFh		  ; DATA XREF: ROM:02BCo
		db 0CDh				  ; call opcode
		db 0C7h	; ¦
		db 0C4h	; -			  ; call nz opcode
		db 0FFh
		db 0C3h				  ; jp opcode
		db 0C7h	; ¦
		db 0C2h	; T			  ; jp nz opcode
						  ; дальше нужно вникать в принцип работы
		db 0E7h				  ; rst	20
		db 22h				  ; ld (nn),hl opcode
		db 0CFh	; ¦			  ; RST	8
		db    1				  ; ld bc,nn
		db 0C7h				  ; RST	0
		db 6				  ; ld b,n
		db 0C7h	; ¦			  ; RST	0
		db 0C6h				  ; add	a,n opcode
		db 0F7h	; ў			  ; RST	30
		db 0D3h				  ; out	(n),a opcode
; ---------------------------------------------------------------------------

program_2E5_super_code_address_correction:	  ; Keyboard read word DE
		rst	30h
		ex	de, hl			  ; некий суперкорректор
						  ; зачем он тут нужен
						  ; и что он делает
						  ; науке неизвестно
						  ;
						  ; xxxx - начальный адрес исходной программы
						  ; хххх - конечный адрес исходной программы
						  ; хххх - адрес коректируемой программы
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F0), hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F4), hl
		push	hl
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F2), hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F6), hl
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_2E5_309_word_C3FA), hl
		pop	de
		ld	a, l
		sub	e
		ld	l, a
		ld	a, h
		sbc	a, d
		ld	h, a
		ld	(var_program_200_25F_2E5_35E_388_word_C3F8), hl
		call	program_25F_correction_266
		rst	0			  ; start

program_309_addres_replace:			  ; Программа замены адресов
		rst	30h			  ;
						  ; xxxx - начальный адрес рабочей программы ?????
						  ; хххх - конечный адрес рабочей программы ?????
						  ; хххх - старый адрес	?????о_О
						  ; хххх - новый адрес ?????о_О
						  ;
						  ; вообще о чем речь? о_О
						  ; лучшо бы впихнули калькулятор
		push	de
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F2), hl
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_2E5_309_word_C3FA), hl
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		ld	(var_program_309_word_C3EE), hl
		pop	hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F0), hl

program_309_31E:				  ; CODE XREF: ROM:035Aj
		ld	d, (hl)
		push	hl
		call	program_25F_call_jp_opcode_detector_2B9
		ld	h, b			  ; ld h,0 ?
		ex	(sp), hl
		ld	a, b
		cp	3
		jp	nz, program_309_34A
		inc	hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		dec	hl
		push	hl
		ld	hl, (var_program_2E5_309_word_C3FA)
		call	cp_HL_DE_259
		jp	nz, program_309_348
		ld	hl, (var_program_309_word_C3EE)
		ex	de, hl
		pop	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
		inc	hl
		inc	sp
		inc	sp
		jp	program_309_350
; ---------------------------------------------------------------------------

program_309_348:				  ; CODE XREF: ROM:0337j
		pop	hl
		dec	hl

program_309_34A:				  ; CODE XREF: ROM:0328j
		pop	bc

program_309_34B:				  ; CODE XREF: ROM:034Dj
		inc	hl
		dec	b
		jp	nz, program_309_34B

program_309_350:				  ; CODE XREF: ROM:0345j
		ld	e, l
		ld	d, h
		ld	hl, (var_program_200_25F_2E5_309_35E_388_word_C3F2)
		inc	hl
		call	cp_HL_DE_259
		ex	de, hl
		jp	nz, program_309_31E
		rst	0			  ; start

program_35E_insert_byte:			  ; Программа вставки байта
		rst	30h			  ;
						  ; xxxx - адрес куда вставить байт
						  ; хххх - адрес конца программы ???????
		ex	de, hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F0), hl
		ld	c, l
		ld	b, h
		rst	30h			  ; Keyboard read word DE
		ld	l, e
		ld	h, d
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F2), hl
		inc	hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F6), hl
		call	program_200_copy_20E
		xor	a
		ld	(hl), a
		push	hl
		inc	hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F4), hl
		ld	hl, 1
		ld	(var_program_200_25F_2E5_35E_388_word_C3F8), hl
		call	program_25F_correction_266
		pop	hl
		ld	a, (hl)
		rst	28h			  ; print HL A on screen
		rst	10h			  ; keyboard read byte A and print loop
		ld	(hl), a
		rst	0			  ; start

program_388_delete_byte:			  ; Программа удаления байта
		rst	30h			  ;
						  ; xxxx - адрес удаляемого байта
						  ; хххх - адрес конца программы ?????
		ex	de, hl
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F0), hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F4), hl
		ld	c, l
		ld	b, h
		push	hl
		rst	30h			  ; Keyboard read word DE
		ld	l, e
		ld	h, d
		ld	(var_program_200_25F_2E5_309_35E_388_word_C3F2), hl
		pop	hl
		push	bc
		inc	bc
		call	program_200_copy_219
		xor	a
		ld	(hl), a
		dec	hl
		ld	(var_program_200_25F_2E5_35E_388_word_C3F6), hl
		ld	hl, 0FFFFh
		ld	(var_program_200_25F_2E5_35E_388_word_C3F8), hl
		call	program_25F_correction_266
		pop	hl
		jp	monitor_2_view_from_HL_7D
; ---------------------------------------------------------------------------

program_3B2_verify_memory_block:		  ; Программа проверки данных
		rst	30h			  ; xxxx - адрес начала	данных
						  ; хххх - адрес конца данных
						  ; хххх - адрес начала	сверяемых данных
		ld	c, e
		ld	b, d
		rst	30h			  ; Keyboard read word DE
		push	de
		rst	30h			  ; Keyboard read word DE
		ex	de, hl
		pop	de

program_3B2_3BA:				  ; CODE XREF: ROM:03D1j
						  ; ROM:03DAj
		ld	a, (bc)
		cp	(hl)
		jp	nz, program_3B2_3D4
		ld	a, c
		cp	e
		jp	nz, program_3B2_3CF
		ld	a, b
		cp	d
		jp	nz, program_3B2_3CF
		ld	a, 11h			  ; пишем что проверка прошла успешно
		ld	l, a
		ld	h, a
		rst	28h			  ; print HL A on screen
		rst	0			  ; start

program_3B2_3CF:				  ; CODE XREF: ROM:03C1j
						  ; ROM:03C6j
		inc	bc
		inc	hl
		jp	program_3B2_3BA
; ---------------------------------------------------------------------------

program_3B2_3D4:				  ; CODE XREF: ROM:03BCj
		push	af
		ld	a, (hl)
		rst	28h			  ; print HL A on screen
		rst	10h			  ; keyboard read byte A and print loop
		ld	(hl), a
		pop	af
		jp	program_3B2_3BA
; ---------------------------------------------------------------------------

program_3DD_regs_indicator:			  ; программа индикации	регистров микропроцессора
		push	bc
		push	de
		push	hl
		push	af
		ld	a, (hl)			  ; наверное имелось ввиду ld a,HLh :)
						  ; но во время	бумажного ассемблирования
						  ; видимо ВНЕЗАПНО обрело дополнительные скобки
						  ; чего добились навешиванием пзушки со шрифтом непонятно
		rst	28h			  ; print HL A on screen
		rst	20h			  ; keyboard read A loop
		ex	(sp), hl
		ld	a, 0AFh	; 'п'             ; оно же "AF"
		rst	28h			  ; print HL A on screen
		rst	20h			  ; keyboard read A loop
		ex	(sp), hl
		ld	l, c
		ld	h, b
		ld	a, 0BCh	; '-'             ; так же известное как "BC"
		rst	28h			  ; print HL A on screen
		rst	20h			  ; keyboard read A loop
		ex	de, hl
		ld	a, 0DEh	; '¦'             ; итд
		rst	28h			  ; print HL A on screen
		rst	20h			  ; keyboard read A loop
		pop	af
		pop	hl
		pop	de
		pop	bc
		ret
; ---------------------------------------------------------------------------
		rst	38h			  ; 1Hz	int
		rst	38h			  ; 1Hz	int
		rst	38h			  ; 1Hz	int
		rst	38h			  ; 1Hz	int
		rst	38h			  ; 1Hz	int
		rst	38h			  ; 1Hz	int


; ===========================================================================




video_ram_9000 = $9000				  ; DATA XREF: ROM:print_HL_A_28w
						  ; ROM:003Cw ROM:004Cw
						  ; ROM:0051w

video_ram_9001 = $9001				  ; DATA XREF: ROM:002Bw
video_ram_9002 = $9002



; ===========================================================================


ram_start_C000 = $C000				  ; CODE XREF: ROM:monitor_6_run_C000_25j
						  ; DATA XREF: ROM:monitor_2_view_from_C000_7Ao
						  ; ROM:monitor_1_write_from_C000_8Ao
						  ; ROM:monitor_4_ram_test_A3o
		

var_program_309_word_C3EE = $C3EE		  ; DATA XREF: ROM:0317w
						  ; ROM:033Ar

var_program_200_25F_2E5_309_35E_388_word_C3F0 = $C3F0	; DATA XREF:	ROM:022Cw
						  	; ROM:0247r ROM:027Cr
						  	; ROM:02E7w ROM:031Bw
						  	; ROM:0360w ROM:038Aw

var_program_200_25F_2E5_309_35E_388_word_C3F2 = $C3F2	; DATA XREF:	ROM:0228w
						  	; ROM:023Fr ROM:0286r
						  	; ROM:02F0w ROM:030Dw
						  	; ROM:0352r ROM:0368w
						  	; ROM:0396w

var_program_200_25F_2E5_35E_388_word_C3F4 = $C3F4	; DATA XREF: ROM:0231w
						  	; ROM:024Dr
						  	; ROM:program_25F_correction_266r
						  	; ROM:02EAw ROM:0376w
						  	; ROM:038Dw

var_program_200_25F_2E5_35E_388_word_C3F6 = $C3F6	; DATA XREF: ROM:0244w
						  	; ROM:0255r ROM:02ADr
						  	; ROM:02F3w ROM:036Cw
						  	; ROM:03A2w

var_program_200_25F_2E5_35E_388_word_C3F8 = $C3F8  	; DATA XREF: ROM:023Aw
						  	; ROM:0290r ROM:0302w
						  	; ROM:037Cw ROM:03A8w

var_program_2E5_309_word_C3FA = $C3Fa		  ; DATA XREF: ROM:02F8w
						  ; ROM:0312w ROM:0331r

var_tape_byte_C3FC = $C3FC			  ; DATA XREF: ROM:0151w
						  ; ROM:015Ew ROM:0167r

var_time_byte_C3FD = $C3FD			  ; DATA XREF: ROM:00C9o
						  ; ROM:01F8r

var_time_word_C3FE = $C3FE			  ; DATA XREF: ROM:time_1F5r


		



endfile

	savebin "ut88_monitor0_disasm.rom", beginfile, endfile-beginfile
