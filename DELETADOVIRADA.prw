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

USER FUNCTION delSXVIRADA()

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
		
			WHILE !EOF()
			
			DBRECALL()
			
			DBSKIP()
			
			ENDDO
			 
		END TRANSACTION
		
		/*
		|---------------------------------------------------------------------------------
		|	Tratamento dos Indices Duplicados
		|---------------------------------------------------------------------------------
		*/
		
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
		
				
		BEGIN TRANSACTION
						
			WHILE !EOF()
			
			DBRECALL()
			
			DBSKIP()
			
			ENDDO
				
		END TRANSACTION 
			

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
		
			WHILE !EOF()
			
			DBRECALL()
			
			DBSKIP()
			
			ENDDO
		
		
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