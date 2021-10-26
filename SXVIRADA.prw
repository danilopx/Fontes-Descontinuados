#INCLUDE 'FILEIO.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DIRECTRY.CH'
#INCLUDE 'TRYEXCEPTION.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	SXVIRADA.prw
=================================================================================
||   Funcao: 	SXVIRADA
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que sera utilizada para manutencao dos SX´s preparando para a 
|| 	Virada de Versao.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		07/04/2016
=================================================================================
=================================================================================
*/

USER FUNCTION SXVIRADA()

LOCAL CLOG		:= ""
LOCAL BERROR	:= {|OERROR| TRATAERRO(OERROR)}
LOCAL OERROR
LOCAL AFILE		:= {}
LOCAL ASX7		:= {}
LOCAL ASIX		:= {}
LOCAL ADELSIX	:= {}
LOCAL ASX3		:= {}
LOCAL ASXG		:= {}
LOCAL I			:= 0
LOCAL CEMPAT	:= ""

/*
|---------------------------------------------------------------------------------
|	Preenchimento dos tratamentos para os Gatilhos duplicados
|---------------------------------------------------------------------------------
*/
AADD(ASX7,{"ED_CGE","001"})
AADD(ASX7,{"ED_CGE","001"})
AADD(ASX7,{"ED_CGE","001"})
AADD(ASX7,{"ED_CGE","001"})
AADD(ASX7,{"ED_CGG","001"})
AADD(ASX7,{"ED_CGG","001"})
AADD(ASX7,{"ED_CGG","001"})
AADD(ASX7,{"ED_CGG","001"})

/*
|---------------------------------------------------------------------------------
|	Preenchimento dos tratamentos para os Indices a serem excluidos
|---------------------------------------------------------------------------------
*/
AADD(ADELSIX,{"FRF"})
AADD(ADELSIX,{"RAX"})
AADD(ADELSIX,{"RHG"})
AADD(ADELSIX,{"SNP"})
AADD(ADELSIX,{"TRA"})
AADD(ADELSIX,{"TRC"})
AADD(ADELSIX,{"TRJ"})
AADD(ADELSIX,{"TRK"})
AADD(ADELSIX,{"TRT"})

/*
|---------------------------------------------------------------------------------
|	Preenchimento dos tratamentos para os Indices duplicados
|---------------------------------------------------------------------------------
*/
AADD(ASIX,{"CB0","B"})
AADD(ASIX,{"CB0","C"})
AADD(ASIX,{"CB0","D"})
AADD(ASIX,{"CB0","E"})
AADD(ASIX,{"CB0","F"})
AADD(ASIX,{"CB0","G"})
AADD(ASIX,{"CB0","H"})
AADD(ASIX,{"CB0","I"})
AADD(ASIX,{"CB0","J"})
AADD(ASIX,{"CB1","3"})
AADD(ASIX,{"CB1","4"})
AADD(ASIX,{"CB2","3"})
AADD(ASIX,{"CB2","4"})
AADD(ASIX,{"CB3","2"})
AADD(ASIX,{"CB4","2"})
AADD(ASIX,{"CB5","2"})
AADD(ASIX,{"CB6","5"})
AADD(ASIX,{"CB6","6"})
AADD(ASIX,{"CB6","7"})
AADD(ASIX,{"CB6","8"})
AADD(ASIX,{"CB7","8"})
AADD(ASIX,{"CB7","9"})
AADD(ASIX,{"CB7","A"})
AADD(ASIX,{"CB7","B"})
AADD(ASIX,{"CB7","C"})
AADD(ASIX,{"CB7","D"})
AADD(ASIX,{"CB7","E"})
AADD(ASIX,{"CB8","9"})
AADD(ASIX,{"CB8","A"})
AADD(ASIX,{"CB8","B"})
AADD(ASIX,{"CB8","C"})
AADD(ASIX,{"CB8","D"})
AADD(ASIX,{"CB8","E"})
AADD(ASIX,{"CB8","F"})
AADD(ASIX,{"CB9","E"})
AADD(ASIX,{"CB9","F"})
AADD(ASIX,{"CB9","G"})
AADD(ASIX,{"CB9","H"})
AADD(ASIX,{"CB9","I"})
AADD(ASIX,{"CB9","J"})
AADD(ASIX,{"CB9","K"})
AADD(ASIX,{"CB9","L"})
AADD(ASIX,{"CB9","M"})
AADD(ASIX,{"CB9","N"})
AADD(ASIX,{"CB9","O"})
AADD(ASIX,{"CB9","P"})
AADD(ASIX,{"CBA","4"})
AADD(ASIX,{"CBA","5"})
AADD(ASIX,{"CBA","6"})
AADD(ASIX,{"CBB","4"})
AADD(ASIX,{"CBB","5"})
AADD(ASIX,{"CBB","6"})
AADD(ASIX,{"CBC","4"})
AADD(ASIX,{"CBC","5"})
AADD(ASIX,{"CBC","6"})
AADD(ASIX,{"CBD","2"})
AADD(ASIX,{"CBE","3"})
AADD(ASIX,{"CBE","4"})
AADD(ASIX,{"CBF","4"})
AADD(ASIX,{"CBF","5"})
AADD(ASIX,{"CBF","6"})
AADD(ASIX,{"CBF","7"})
AADD(ASIX,{"CBF","8"})
AADD(ASIX,{"CBF","9"})
AADD(ASIX,{"CBF","A"})
AADD(ASIX,{"CBF","B"})
AADD(ASIX,{"CBF","C"})
AADD(ASIX,{"CBG","7"})
AADD(ASIX,{"CBG","8"})
AADD(ASIX,{"CBG","9"})
AADD(ASIX,{"CBG","A"})
AADD(ASIX,{"CBG","B"})
AADD(ASIX,{"CBG","C"})
AADD(ASIX,{"CBH","7"})
AADD(ASIX,{"CBH","8"})
AADD(ASIX,{"CBH","9"})
AADD(ASIX,{"CBH","A"})
AADD(ASIX,{"CBH","B"})
AADD(ASIX,{"CBH","C"})
AADD(ASIX,{"CBI","3"})
AADD(ASIX,{"CBI","4"})
AADD(ASIX,{"CBJ","3"})
AADD(ASIX,{"CBJ","4"})
AADD(ASIX,{"CBL","3"})
AADD(ASIX,{"CBM","2"})
AADD(ASIX,{"RHS","2"})
AADD(ASIX,{"SB2","5"})
AADD(ASIX,{"SB7","4"})
AADD(ASIX,{"SC1","C"})
AADD(ASIX,{"SC8","8"})
AADD(ASIX,{"SD2","E"})
AADD(ASIX,{"SE1","W"})
AADD(ASIX,{"SGI","2"})

/*
|---------------------------------------------------------------------------------
|	Preenchimento dos tratamentos para os Grupos de Campos no Dicionario de Dados
|---------------------------------------------------------------------------------
*/
AADD(ASX3,{"CL2","CL2_PARTI"	,""		,0})
AADD(ASX3,{"ELA","ELA_ORIGEM"	,""		,0})
AADD(ASX3,{"ELA","ELA_DTEMIS"	,""		,0})
AADD(ASX3,{"CVD","CVD_CTAREF"	,""		,0})
AADD(ASX3,{"FIM","FIM_CODMUN"	,""		,0})
AADD(ASX3,{"CCQ","CCQ_CODIGO"	,"023"	,9})
AADD(ASX3,{"CGA","CGA_CODISS"	,"023"	,9})
AADD(ASX3,{"CGB","CGB_CODISS"	,"023"	,9})
AADD(ASX3,{"SB4","B4_CODISS"	,"023"	,9})
AADD(ASX3,{"SB1","B1_CODISS"	,"023"	,9})
AADD(ASX3,{"SD1","D1_CODISS"	,"023"	,9})
AADD(ASX3,{"SD2","D2_CODISS"	,"023"	,9})
AADD(ASX3,{"SF3","F3_CODISS"	,"023"	,9})
AADD(ASX3,{"SFT","FT_CODISS"	,"023"	,9})
AADD(ASX3,{"SC6","C6_CODISS"	,"023"	,9})
AADD(ASX3,{"SC9","C9_CODISS"	,"023"	,9})
AADD(ASX3,{"SBZ","BZ_CODISS"	,"023"	,9})
AADD(ASX3,{"SS4","S4_CODISS"	,"023"	,9})
AADD(ASX3,{"SS6","S6_CODISS"	,"023"	,9})
AADD(ASX3,{"ZGB","ZGB_CODISS"	,"023"	,9})
AADD(ASX3,{"SRK","RK_POSTO"		,""		,0})
AADD(ASX3,{"CLY","CLY_GRUPO"	,""		,0})
AADD(ASX3,{"EJW","EJW_TPPROC"	,""		,0})
AADD(ASX3,{"F02","F02_VLDEDU"	,""		,0})
AADD(ASX3,{"F02","F02_VLTOTN"	,""		,0})

/*
|---------------------------------------------------------------------------------
|	Preenchimento dos tratamentos para os Grupos de Campos 
|---------------------------------------------------------------------------------
*/
AADD(ASXG,{"023"	,9})
AADD(ASXG,{"031"	,8})

TRYEXCEPTION USING BERROR
	
	RESET ENVIRONMENT
	AEVAL(DIRECTORY("\SYSTEM\*.CDX"), { |AFILE| FERASE(AFILE[F_NAME]) })
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1"
	
	/*
	|---------------------------------------------------------------------------------
	|	Abre arquivo de Empresa para poder realizar manutenção em todas as empresas 
	|---------------------------------------------------------------------------------
	*/	
	DBSELECTAREA("SM0")
	DBGOTOP()
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Inicio de todo o processo de correcoes necessarias para poder realizar 
	|	a Virada de Versao 11.8 para 12.0.7
	|=================================================================================
	*/
	WHILE SM0->(!EOF())
		
		CEMPAT := SM0->M0_CODIGO
		
		RPCSETTYPE(3)  // NAO UTILIZAR LICENCA
		RPCSETENV(SM0->M0_CODIGO,SM0->M0_CODFIL,,,,GETENVSERVER(),{ "SA1" })
		SLEEP( 5000 )
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SIX (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SIXTMP","SIX",,.F.)
		CONOUT("[INFO] - Abrindo SIX da Empresa " + ALLTRIM(SM0->M0_CODIGO) + " - Filial " + ALLTRIM(SM0->M0_CODFIL))
		DBSELECTAREA("SIXTMP")
		DBGOTOP()				
		
		/*
		|---------------------------------------------------------------------------------
		|	Exclusao de todos os Indices para as tabelas
		|---------------------------------------------------------------------------------
		*/
		BEGIN TRANSACTION
		
			FOR I := 1 TO LEN(ADELSIX)
			
				IF DBSEEK(ADELSIX[I][1])
					
					CONOUT("[INFO ] - Achou Indice " + ADELSIX[I][1] + "...")
									
					WHILE SIXTMP->(!EOF()) .AND. INDICE = ADELSIX[I][1]
						
						IF RECLOCK("SIXTMP",.F.)
							
							DBDELETE()
							MSUNLOCK()
							CONOUT("[INFO ] - Deletou Indice " + ADELSIX[I][1] + " - Ordem " + CVALTOCHAR(SIXTMP->ORDEM))
							
						ENDIF 
						SIXTMP->(DBSKIP())
						
					ENDDO
										
				ENDIF
			
			NEXT I
			 
		END TRANSACTION
		
		/*
		|---------------------------------------------------------------------------------
		|	Tratamento dos Indices Duplicados
		|---------------------------------------------------------------------------------
		*/
		CONOUT("[INFO ] - Iniciando tratamento de Indices duplicados...")
		
		FOR I := 1 TO LEN(ASIX)
			
			IF DBSEEK(ASIX[I][1] + ASIX[I][2])
				
				BEGIN TRANSACTION
					
					IF RECLOCK("SIXTMP",.F.)
						
						DBDELETE()
						MSUNLOCK()
						CONOUT("[INFO ] - Deletou Indice " + ASIX[I][1] + " - Ordem " + ASIX[I][2])
						
					ENDIF
					
				END TRANSACTION
				
			ENDIF
			
		NEXT I 
		
		DBSELECTAREA("SIXTMP")
		DBCLOSEAREA()
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SX7 (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SX7TMP","SX7",,.F.)
		CONOUT("[INFO ] - Abrindo SX7 da Empresa " + ALLTRIM(SM0->M0_CODIGO) + " - Filial " + ALLTRIM(SM0->M0_CODFIL))
		DBSELECTAREA("SX7TMP")
		DBGOTOP()
		
		CONOUT("[INFO ] - Iniciando tratamento de Gatilhos duplicados...")
		
		FOR I := 1 TO LEN(ASX7)
		
			IF DBSEEK(PADR(ASX7[I][1],10) + ASX7[I][2])
				
				BEGIN TRANSACTION
						
					IF RECLOCK("SX7TMP",.F.)
						
						DBDELETE()
						MSUNLOCK()
						CONOUT("[INFO ] - Deletou Gatilho " + ASX7[I][1] + " - Ordem " + ASX7[I][2])
						
					ENDIF 
				
				END TRANSACTION 
			
			ENDIF
			
		NEXT I

		DBSELECTAREA("SX7TMP")
		DBCLOSEAREA()
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SX3 (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SX3TMP","SX3",,.F.)
		CONOUT("[INFO ] - Abrindo SX3 da Empresa " + ALLTRIM(SM0->M0_CODIGO) + " - Filial " + ALLTRIM(SM0->M0_CODFIL))
		DBSELECTAREA("SX3TMP")
		DBSETORDER(2)
		DBGOTOP()
		
		CONOUT("[INFO ] - Iniciando tratamento de Grupos de Campos no SX3...")
		
		FOR I := 1 TO LEN(ASX3)
		
			IF DBSEEK(ASX3[I][2])
				
				IF RECLOCK("SX3TMP",.F.)
					
					SX3TMP->X3_GRPSXG 	:= ASX3[I][3]
					SX3TMP->X3_TAMANHO 	:= IIF(!EMPTY(ASX3[I][3]),ASX3[I][4],SX3TMP->X3_TAMANHO)
					MSUNLOCK()
					CONOUT("[INFO ] - Corrigiu Grupo no SX3 para campo " + ASX3[I][2])
					
				ENDIF
				
			ENDIF
			
		NEXT I  
		
		/*
		|---------------------------------------------------------------------------------
		|	Exclui todos os campos da Tabela SEK que nao existe no SX2
		|---------------------------------------------------------------------------------
		*/
		DBSELECTAREA("SX3TMP")
		DBSETORDER(1)
		IF DBSEEK("SEK")
			
			WHILE SX3TMP->(!EOF()) .AND. SX3TMP->X3_ARQUIVO == "SEK"
				
				IF RECLOCK("SX3TMP",.F.)
					
					DBDELETE()
					MSUNLOCK()
					CONOUT("[INFO ] - Exclusao do campo " + SX3TMP->X3_CAMPO + " do SX3")
					
				ENDIF 
				SX3TMP->(DBSKIP())
				
			ENDDO
			
		ENDIF 
		
		DBSELECTAREA("SX3TMP")
		DBCLOSEAREA()
		
		/*
		|---------------------------------------------------------------------------------
		|	Realiza a atualizacao fisica das tabelas alteradas no Dicionario de Dados
		|---------------------------------------------------------------------------------
		*/		
		CONOUT("[INFO] - Atualizacao do SX3")
		__SETX31MODE( .F. )
		ASORT(ASX3,,,{|X,Y| (X[1] + X[2]) < (Y[1] + Y[2])})
		
		FOR I := 1 TO LEN(ASX3)
		
			X31UPDTABLE( ASX3[I][1] )
			
			IF __GETX31ERROR()
				CONOUT( __GETX31TRACE() )
				CONOUT( "OCORREU UM ERRO DESCONHECIDO DURANTE A ATUALIZAÇÃO DA TABELA : " + ASX3[I] + ". VERIFIQUE A INTEGRIDADE DO DICIONÁRIO E DA TABELA.")
			ENDIF
			
		NEXT I 
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SXG (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SXGTMP","SXG",,.F.)
		CONOUT("[INFO ] - Abrindo SXG da Empresa " + ALLTRIM(SM0->M0_CODIGO) + " - Filial " + ALLTRIM(SM0->M0_CODFIL))
		DBSELECTAREA("SXGTMP")
		DBGOTOP()
		
		CONOUT("[INFO ] - Iniciando tratamento de Grupos de Campos no SXG...")
		
		FOR I := 1 TO LEN(ASXG)
			
			IF DBSEEK(ASXG[I][1])
				
				IF RECLOCK("SXGTMP",.F.)
					
					SXGTMP->XG_SIZE := ASXG[I][2]
					MSUNLOCK()
					
				ENDIF
				
			ENDIF
			
		NEXT I 
		
		DBSELECTAREA("SXGTMP")
		DBCLOSEAREA()
		
		/*
		|---------------------------------------------------------------------------------
		|	Roda somente para uma filial. Nao eh necessario o tratamento por filiais.
		|---------------------------------------------------------------------------------
		*/
		WHILE CEMPAT == SM0->M0_CODIGO
			SM0->(DBSKIP())
		ENDDO 
		
	ENDDO
	
	RESET ENVIRONMENT
	
	CONOUT("[INFO] - FIM DO PROCESSO!")
			
CATCHEXCEPTION USING OERROR
	
	CONOUT("Warning --> OCORREU UM ERRO DE PROCESSAMENTO!")
	RESET ENVIRONMENT
	
ENDEXCEPTION	

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	SXVIRADA.prw
=================================================================================
||   Funcao: 	TRATAERRO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Bloco de código para tratamento de Erros 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:		07/04/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION TRATAERRO(OERROR)

	CONOUT("Warning -->" + ENTER + OERROR:DESCRIPTION + ENTER + OERROR:ERRORSTACK)
	BREAK

RETURN