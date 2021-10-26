#INCLUDE "protheus.ch"
#INCLUDE "ap5mail.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE MAXPASSO 10
#DEFINE CRLF ( chr(13)+chr(10) )
#DEFINE INICABEC    Chr(27)+Chr(01)+Chr(01)
#DEFINE FIMCABEC    Chr(27)+Chr(01)+Chr(02)
#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
// Constantes para identificar o tipo de impress�o.
#DEFINE IMP_DISCO 1
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PORTA 3
#DEFINE IMP_EMAIL 4

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMRL008  � Autor � Paulo Bindo        � Data �  20/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Rel. Valores                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMRL008()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

	Local cDesc1    	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     	:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3      	:= "Relatorio de Valores."
	//Local cPict       	:= ""
	Local titulo
	Local nLin        	:= 80


//	Local Cabec1       := "            P R E V.  F A T U R A M. |  F A T U R A M E N T O   | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |             E S T O Q U E             |   PROGRAMA��O DA PRODUCAO     |   P R O D U C A O   R E A L   |"
//	Local Cabec2       := "              Taiff    ASTEC         |   Taiff    ASTEC         |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |            R    E    A    L           |    Sec             Chp        |    Sec             Chp        |"
//	Local Cabec3       := "Dia           Valor    Valor    Acum.|   Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  Quant   Acum.   Quant   Acum.|  Quant   Acum.   Quant   Acum.|"


	Local Cabec1       := "            P R E V.  F A T U R A M. |  F A T U R A M E N T O   | ESTOQUE | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |     E S T O Q U E     |   PROGRAMA��O DA PRODUCAO     |   P R O D U C A O   R E A L   |"
	Local Cabec2       := "              Taiff    ASTEC         |   Taiff    ASTEC         | R E A L |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |    R    E    A    L   |    Sec             Chp        |    Sec             Chp        |"
	Local Cabec3       := "Dia           Valor    Valor    Acum.|   Valor    Valor    Acum.| PA(N+I) |   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os. |  Quant   Acum.   Quant   Acum.|  Quant   Acum.   Quant   Acum.|"

		//                 99/99/99 SEG  99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999
		
		//             "            10        20        30        40        50        60        70        80        90        100       110       120"      130       140       150       160       170       180       190       200       210       220       230       240       250       260       270 
		//             "   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"

	//Local imprime      := .T.
	//Local aOrd := {}
	//Local aUsers
	//Local lOk			:= .F.
	Local nLpMarca		:= 0

	Private PCabec1      := "            P R E V.  F A T U R A M. |  F A T U R A M E N T O   | ESTOQUE | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |     E S T O Q U E     |"
	Private PCabec2      := "             ProArt    ASTEC         |  ProArt    ASTEC         | R E A L |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |    R    E    A    L   |"
	Private PCabec3      := "Dia           Valor    Valor    Acum.|   Valor    Valor    Acum.| PA(N+I) |   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os. |"

	Private GCabec1      := "                  P R E V.  F A T U R A M.     |        F A T U R A M E N T O      | ESTOQUE | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |     E S T O Q U E     |"
	Private GCabec2      := "              Taiff   ProArt     ASTEC         |   Taiff   ProArt    ASTEC         | R E A L |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |    R    E    A    L   |"
	Private GCabec3      := "Dia           Valor    Valor     Valor    Acum.|   Valor    Valor    Valor    Acum.| PA(N+I) |   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os. |"
		//                   99/99/99 SEG  99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999

//	Private aEmpresas 		:= {{"04","ZZ",1},{"ZZ","ZZ",4}}
	//Private aEmpresas 		:= {{"03","ZZ",1},{"04","ZZ",1},{"ZZ","ZZ",4}}
	Private aEmpresas 		:= {{"03","ZZ",1},{"04","ZZ",1},{"ZZ","ZZ",4}}
	Private aMarcas 			:= {"TAIFF","PROART",""}

	Private lEnd         	:= .F.
	Private lAbortPrint  	:= .F.
	Private limite          := 220
	Private tamanho         := "G"
	Private nomeprog        := "COMRL008" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 1, 1, "", 1}
	Private nLastKey        := 0
	Private cPerg       	:= "CORL04"
	Private cbtxt      		:= Space(10)
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "COMRL008" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nQtCol				:= 280

	Private cString := "SD2"
	Private lAuto := .F.
	Private aAtu		:= {} //{01-DATA, 02-DIA SEM, 03-COMPRAS SERV, 04-COMPRAS PROD, 05-COMPRAS ACUM, 06-FAT PROD, 07-FAT SERV, 08-FAT ACUM, 09-PEDVEN PROD, 10-PEDVEN SERV, 11-PEDVEN ACUM, 12-PREV COMPRAS MP, 13- PREV COMPRAS SERV, 14- PREV COMPRAS SOLC, 15-PREV COMPRAS ACUM}
	Private nPedVMAnt 	:= 0 //PEDIDO DE VENDAS MANUTENCAO ANTERIOR
	Private nPedVPAnt 	:= 0 //PEDIDO DE VENDAS PRODUTO ANTERIOR
	Private nPedVSAnt 	:= 0 //PEDIDO DE VENDAS PROART ANTERIOR
	Private nPedVWAnt 	:= 0 //PEDIDO DE VENDAS TAIFF ANTERIOR
	Private nPedVPPos 	:= 0 //PEDIDO DE VENDAS INATIVO POSTERIOR
	Private nPedVSPos 	:= 0 //PEDIDO DE VENDAS PROART POSTERIOR
	Private nPedVWPos 	:= 0 //PEDIDO DE VENDAS TAIFF POSTERIOR
	Private nPedSMntPos	:= 0 //PEDIDO DE VENDAS MANUTENCAO POSTERIOR
	Private nPedCPAnt 	:= 0 //PEDIDO DE COMPRAS PRODUTO ANTERIOR
	Private nPedCSAnt 	:= 0 //PEDIDO DE COMPRAS SERVICO ANTERIOR
	Private nPedCPPos 	:= 0 //PEDIDO DE COMPRAS PRODUTO POSTERIOR
	Private nPedCSPos 	:= 0 //PEDIDO DE COMPRAS SERVICO POSTERIOR
	Private nSolAnt 	:= 0 //SOLICITACAO DE COMPRAS ANTERIOR
	Private nSolPos 	:= 0 //SOLICITACAO DE COMPRAS POSTERIOR
	Private nSolsPos 	:= 0 //SOLICITACAO DE COMPRAS PARA O MES SUBSEQUENTE
	Private nPedVPsPos	:= 0 //PEDIDOS VENDAS PRODUTOS PARA O MES SUBSEQUENTE INATIVO
	Private nPedVWsPos	:= 0 //PEDIDOS VENDAS TAIFF PARA O MES SUBSEQUENTE
	Private nPedVSsPos	:= 0 //PEDIDOS VENDAS PROART PARA O  MES SUBSEQUENTE
	Private nPedMntPos	:= 0 //PEDIDOS VENDAS MANUTENCAO PARA O MES SUBSEQUENTE
	Private nPedCPsPos	:= 0 //PEDIDOS COMPRAS PRODUTOS PARA O MES SUBSEQUENTE
	Private nPedCSsPos	:= 0 //PEDIDOS COMPRAS SERVICOS PARA O MES SUBSEQUENTE
	Private nPedMnt		:= 0 //PEDIDOS VENDA MANUTENCAO
	Private nNFDev		:= 0 //NOTAS DEVOLUCAO
	Private nPRO		:= 0
	Private oObj
	Private lWeb
	Private cEmailAdm
	Private nVezes		:= 0
	Private lFim		:= .F.
	Private CMARCA		:= ""
	
//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		For nLpMarca := 1 to len(aMarcas)
			CMARCA		:= aMarcas[nLpMarca]
			//For Kz:=1 To Len(aEmpresas)
			Kz:=1 
				cFilialSch  := Iif(aEmpresas[Kz][2]=="ZZ","01",aEmpresas[Kz][2])
				cEmpSch 	:= Iif(aEmpresas[Kz][1]=="ZZ","01",aEmpresas[Kz][1])
				nVezes 		:= aEmpresas[Kz][3]
				wnrel 		:= "COMRL008"+cEmpSch+"_"+cEmpSch
				RPCSetType(3)  // Nao utilizar licenca
				PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"
				dDataBase :=  Date()
				PutMv("MV_IMPSX1","N")
				
				lWeb	  	:= IsBlind()
				//titulo      	:= "Relatorio Valores Empresa "+Iif(aEmpresas[Kz][1]=="ZZ","GERAL",AllTrim(SM0->M0_NOME))+"/"+Iif(aEmpresas[Kz][2]=="ZZ","CONSOLIDADO",SM0->M0_FILIAL)
				titulo      	:= "VALORES DA EMPRESA - " + Iif(EMPTY(CMARCA),"VIS�O CONSOLIDADA","VISAO DA MARCA: " + CMARCA)
				ConOut(Titulo)
				wnrel := Iif(wnrel == nil,nomeprog,wnrel)
				dData :=   Date() //CTOD("03/08/15")
			//VERIFICA SE E O PRIMEIRO DIA ULTIL DO MES E GERA DO MES ANTERIOR
				If Day(dData) <=3
					If Day(dData) == 1  .And. dData == DataValida(dData)
						dData := LastDay(dData - 2)
				//		lFim := .T.
					ElseIf Day(dData) == 2  .And. dData == DataValida(dData) .And. dData-1 # DataValida(dData-1)
						dData := LastDay(dData - 3)
				//		lFim := .T.
					ElseIf Day(dData) == 3  .And. dData == DataValida(dData) .And. dData-2 # DataValida(dData-2) .And. dData-1 # DataValida(dData-1)
						dData := LastDay(dData - 4)
				//		lFim := .T.
					ElseIf Day(dData) == 4  .And. dData == DataValida(dData) .And. dData-3 # DataValida(dData-3) .And. dData-2 # DataValida(dData-2)
						dData := LastDay(dData - 5)
				//		lFim := .T.
					EndIf
				EndIf
			
				mv_par01 := FirstDay(dData)
				mv_par02 := LastDay(dData)
				mv_par03 := FirstDay(dData)
				mv_par04 := LastDay(dData)
				mv_par05 := Iif(aEmpresas[Kz][2]=="ZZ","",aEmpresas[Kz][2])
				mv_par06 := Iif(aEmpresas[Kz][2]=="ZZ","ZZ",aEmpresas[Kz][2])
			
			// forca a geracao do relatorio em disco
				__AIMPRESS[1]:=1
				
			
			//                  1       2        3     4       5      6      7      8   9    10  11        12  13   14 15 16   17
				wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho, ,.f., , ,lWeb, .T. )
			
				
				If nLastKey == 27
					Set Filter To
					Return
				EndIf
			
				SetDefault(aReturn,cString,,lWeb)
			
				If nLastKey == 27
					Set Filter To
					Return
				EndIf
			
				nTipo := If(aReturn[4]==1,15,18)
			
				cEmailAdm := ""//GETMV("MV_WFADMIN") //armazena os e-mails
			
				RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin)
				PutMv("MV_IMPSX1","S")
	
				RESET ENVIRONMENT
			//Next
		Next
		Return
	EndIf

	cEmailAdm := "" //GETMV("MV_WFADMIN") //armazena os e-mails


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
	Validperg(cPerg)
	pergunte(cPerg,.F.)


//                  1       2        3     4       5      6      7      8   9    10  11        12  13   14 15 16   17
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho, ,.f., , ,lWeb, .T. )

	If nLastKey == 27
		Set Filter To
		Return
	EndIf

	SetDefault(aReturn,cString,,lWeb)

	If nLastKey == 27
		Set Filter To
		Return
	EndIf

	nTipo := If(aReturn[4]==1,15,18)


	oObj := MsNewProcess():New({|lEnd| RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin)},"","",.F.)
	oObj :Activate()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  02/04/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin)

	//Local nOrdem
	
	Local aSEMPER := {15,20,25,40} // PERCENTUAL SEMANAL DE PREVIS�O DE VENDAS DEFINIDO PELA DIRETORIA

	Local NTRB5MPI  := 0
	Local NTRB5MPN  := 0
	Local NTRB5PAI  := 0
	Local nTrb3Cont := 0
	Local n			:= 0
	Local nTrb3Loop := 0
	Local Z			:= 0
	Local kk		:= 0

	Private nRecA := 0
	Private nRecB := 0
	Private nRecC := 0
	Private nRecD := 0
	Private nRecE := 0
	Private nRecF := 0
	Private nRecG := 0
	Private nRecH := 0
	Private nRecKC:= 0
	Private nRecHA:= 0
	Private cTEXT   := "Processo "
	nPedVMAnt 	:= 0 //PEDIDO DE VENDAS MANUTENCAO ANTERIOR
	nPedVPAnt 	:= 0 //PEDIDO DE VENDAS PRODUTO ANTERIOR
	nPedVSAnt 	:= 0 //PEDIDO DE VENDAS PROART ANTERIOR
	nPedVWAnt 	:= 0 //PEDIDO DE VENDAS TAIFF ANTERIOR
	nPedVPPos 	:= 0 //PEDIDO DE VENDAS INATIVO POSTERIOR
	nPedVSPos 	:= 0 //PEDIDO DE VENDAS PROART POSTERIOR
	nPedVWPos 	:= 0 //PEDIDO DE VENDAS TAIFF POSTERIOR
	nPedSMntPos	:= 0 //PEDIDO DE VENDAS MANUTENCAO POSTERIOR
	nPedCPAnt 	:= 0 //PEDIDO DE COMPRAS PRODUTO ANTERIOR
	nPedCSAnt 	:= 0 //PEDIDO DE COMPRAS SERVICO ANTERIOR
	nPedCPPos 	:= 0 //PEDIDO DE COMPRAS PRODUTO POSTERIOR
	nPedCSPos 	:= 0 //PEDIDO DE COMPRAS SERVICO POSTERIOR
	nSolAnt 	:= 0 //SOLICITACAO DE COMPRAS ANTERIOR
	nSolPos 	:= 0 //SOLICITACAO DE COMPRAS POSTERIOR
	nSolsPos 	:= 0 //SOLICITACAO DE COMPRAS PARA O MES SUBSEQUENTE
	nPedVPsPos	:= 0 //PEDIDOS VENDAS PRODUTOS PARA O MES SUBSEQUENTE INATIVO
	nPedVWsPos	:= 0 //PEDIDOS VENDAS TAIFF PARA O MES SUBSEQUENTE
	nPedVSsPos	:= 0 //PEDIDOS VENDAS PROART PARA O  MES SUBSEQUENTE
	nPedMntPos	:= 0 //PEDIDOS VENDAS MANUTENCAO PARA O MES SUBSEQUENTE
	nPedCPsPos	:= 0 //PEDIDOS COMPRAS PRODUTOS PARA O MES SUBSEQUENTE
	nPedCSsPos	:= 0 //PEDIDOS COMPRAS SERVICOS PARA O MES SUBSEQUENTE
	nPedMnt		:= 0 //PEDIDOS VENDA MANUTENCAO
	nNFDev		:= 0
	aResult		:= {}

	dbSelectArea(cString)
	dbSetOrder(1)

	For kk:=1 To nVezes
		cNEmpAnt := cEmpAnt+"0"
		If nVezes > 1
			cNEmpAnt := StrZero(kk,2)+"0"
		EndIf
		CNACTION := "040"
	//------------------------------------------------------------------------------------------------------------------//	 
	//----------------------------------------------[COMPRAS REALIZADO]-------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	// NF ENTRADA MATERIA PRIMA
		//------------------------------------------------------------------------------------------------------------------------------
		// Observa��es:
		// O campo F1_HAWB registra o vinculo com PO da tabela do SIGAEIC e o TES na SD1 n�o est� vinculado com o financeiro.
		// N�o ser�o consideradas as entradas da ACTION INDAIATUBA
		//------------------------------------------------------------------------------------------------------------------------------
		cQuery := " SELECT D1_DTDIGIT,SUM(D1_TOTAL+((D1_TOTAL*D1_IPI)/100)+D1_ICMSRET)/1000 TOTAL_MP, F4_ESTOQUE , B1_TIPO," + CRLF
		cQuery += " (CASE WHEN D1_ITEMCTA = '' THEN B1_ITEMCC ELSE D1_ITEMCTA END) AS D1_ITEMCTA, F1_HAWB " + CRLF
		cQuery += " FROM "+("SD1"+CNACTION)+" D1 WITH(NOLOCK), "+("SF4"+CNACTION)+" F4 WITH(NOLOCK),"+("SA2"+CNACTION)+"  A2 WITH(NOLOCK), "+("SB1"+CNACTION)+" B1 WITH(NOLOCK), "+("SF1"+CNACTION)+" F1 WITH(NOLOCK)" + CRLF
		cQuery += " WHERE D1_TES = F4_CODIGO AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_<> '*' AND D1_TIPO = 'N'" + CRLF
		cQuery += " AND A2_COD = D1_FORNECE  AND A2_LOJA = D1_LOJA  AND A2.D_E_L_E_T_<> '*'"+Iif(CNACTION=="030"," AND A2_FILIAL = D1_FILIAL","") + CRLF
		cQuery += " AND D1_DTDIGIT between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "+Iif(CNACTION=="030"," AND F4_FILIAL = D1_FILIAL","") + CRLF
		cQuery += " AND D1_FILIAL BETWEEN '02' AND '02' " + CRLF
		cQuery += " AND A2_CGC NOT IN ('59524199000108','04265582000199','04370561000133','03801629000129','04265582000350','04370561000214','03801629000200','04370561000303','59524199000280')" + CRLF
		cQuery += " AND B1_COD = D1_COD"+Iif(CNACTION=="030"," AND D1_FILIAL = B1_FILIAL","") + CRLF
		cQuery += " AND D1_FORNECE <> 'UNIAO' AND D1_COD <> '977000021'" + CRLF
		cQuery += " AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1.D_E_L_E_T_<> '*' AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA" + CRLF
		cQuery += " AND (F1_HAWB!='' OR (F1_HAWB='' AND F4_DUPLIC='S'))" + CRLF 
		cQuery += " GROUP BY D1_DTDIGIT, F4_ESTOQUE, B1_TIPO, D1_ITEMCTA, F1_HAWB, B1_ITEMCC" + CRLF
		cQuery += " ORDER BY D1_DTDIGIT, F4_ESTOQUE" + CRLF
		MemoWrite("COMRL008"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB1',.F.,.T.)
		Count To nRecA
		TCSETFIELD("TRB1","D1_DTDIGIT","D")
	
	//------------------------------------------------------------------------------------------------------------------//	 
	//----------------------------------------------[FATURAMENTO REALIZADO]---------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	// FATURAMENTO POR PRODUTO TAIFFPROART
		cQuery := " SELECT D2_EMISSAO,Sum(D2_TOTAL+D2_VALIPI+D2_ICMSRET)/1000 TOTAL_FAT, D2_ITEMCC, D2_SERIE " + CRLF
		cQuery += " FROM SD2030 D2 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SF4030 F4 WITH(NOLOCK) ON D2_TES = F4_CODIGO AND F4_FILIAL = D2_FILIAL" + CRLF
		cQuery += " INNER JOIN SF2030 F2 WITH(NOLOCK) ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL" + CRLF
		cQuery += " WHERE F4_DUPLIC = 'S' AND D2_TIPO = 'N' AND D2.D_E_L_E_T_ <> '*'  AND F4.D_E_L_E_T_ <> '*'   AND F2.D_E_L_E_T_ <> '*'" + CRLF
		cQuery += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'" + CRLF
		cQuery += "	AND D2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'" + CRLF
		cQuery += " AND D2_INTER <> 'S'" + CRLF
		cQuery += " GROUP BY D2_EMISSAO, D2_ITEMCC, D2_SERIE  " + CRLF
		// U N I O N   A L L
		cQuery += " UNION ALL "  + CRLF
		// FATURAMENTO POR PRODUTO ACTION
		cQuery += " SELECT D2_EMISSAO,Sum(D2_TOTAL+D2_VALIPI+D2_ICMSRET)/1000 TOTAL_FAT, D2_ITEMCC, D2_SERIE " + CRLF
		cQuery += " FROM SD2040 D2 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SF4040 F4 WITH(NOLOCK) ON D2_TES = F4_CODIGO " + CRLF
		cQuery += " INNER JOIN SF2040 F2 WITH(NOLOCK) ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL" + CRLF
		cQuery += " WHERE F4_DUPLIC = 'S' AND D2_TIPO = 'N' AND D2.D_E_L_E_T_ <> '*'  AND F4.D_E_L_E_T_ <> '*'   AND F2.D_E_L_E_T_ <> '*'" + CRLF
		cQuery += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'" + CRLF
		cQuery += " AND D2_FILIAL = '02'" + CRLF
		cQuery += " AND D2_INTER <> 'S'" + CRLF
		cQuery += " GROUP BY D2_EMISSAO, D2_ITEMCC, D2_SERIE  " + CRLF

		cQuery += " ORDER BY D2_EMISSAO" + CRLF
	
		MemoWrite("COMRL008A"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB2',.F.,.T.)
		Count To nRecB
		TCSETFIELD("TRB2","D2_EMISSAO","D")
	//------------------------------------------------------------------------------------------------------------------//	 
	//------------------------------------------[FIM FATURAMENTO REALIZADO]---------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 


	//PEDIDOS EM ABERTO POR ITEM CONFORME PARAMETROS
	/*
		cQuery := " SELECT C6_ENTREG, Sum(C6_PRCVEN*(C6_QTDVEN-C6_QTDENT))/1000 TOTAL, C6_XITEMC, LEFT(C6_CLASSFIS,1) AS C6_ORIGEM, C5_CLASPED " + CRLF
		cQuery += " FROM "+("SC6"+cNEmpAnt)+" C6 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN  "+("SC5"+cNEmpAnt)+" C5 WITH(NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM" + CRLF
		cQuery += " INNER JOIN "+("SF4"+cNEmpAnt)+" F4 WITH(NOLOCK) ON C6_TES = F4_CODIGO "+Iif(cNEmpAnt=="030"," AND F4_FILIAL = C6_FILIAL","")" + CRLF
		cQuery += " WHERE  " + CRLF
		cQuery += " C6.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND C6_QTDENT < C6_QTDVEN AND F4_DUPLIC = 'S' AND C5_TIPO NOT IN ('B','D') AND C6_BLQ NOT IN ('R','S') AND C6_ENTREG <> ''" + CRLF
		cQuery += " AND C6_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'  AND C5_INTER <> 'S'" + CRLF
		cQuery += " AND C6_ENTREG >= '"+Dtos(dDatabase-120)+"'" + CRLF
		cQuery += " GROUP BY C6_ENTREG, C6_XITEMC,LEFT(C6_CLASSFIS,1), C5_CLASPED" + CRLF
		cQuery += " ORDER BY C6_ENTREG" + CRLF
	
		MemoWrite("COMRL008C"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB3',.F.,.T.)
		Count To nRecC
		TCSETFIELD("TRB3","C6_ENTREG","D")
	*/
	//------------------------------------------------------------------------------------------------------------------//	 
	//-------------------------------------------------[OR�ADO FATURAMENTO]---------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	// MARCA: TAIFF
	//OR�ADO DE FATURAMENTO - (META SOBRE PERCENTUAIS FIXOS POR SEMANA 1a sem 15% - 2a sem 20% - 3a sem 25% - 4a sem 40%)
		cQuery := " SELECT SUM(CT_VALOR)/1000 AS TOTAL" + CRLF
		cQuery += " FROM METAS_CONGELADAS SCT WITH(NOLOCK)" + CRLF
		cQuery += " WHERE  " + CRLF
		cQuery += " SCT.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND SCT.CT_VEND != '000511' " + CRLF
		cQuery += " AND CT_DOC='MR" + SUBSTR(Dtos(mv_par01),3,4) + "-MO'" + CRLF
	
		MemoWrite("COMRL008C"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB3',.F.,.T.)
		Count To nRecC
	 
	// MARCA: ASTEC
	//OR�ADO DE FATURAMENTO - (META ASTEC  SOBRE PERCENTUAIS FIXOS POR SEMANA 1a sem 25% - 2a sem 25% - 3a sem 25% - 4a sem 25%)
		cQuery := " SELECT SUM(CT_VALOR)/1000 AS TOTAL" + CRLF
		cQuery += " FROM METAS_CONGELADAS SCT WITH(NOLOCK)" + CRLF
		cQuery += " WHERE  " + CRLF
		cQuery += " SCT.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND SCT.CT_VEND = '000511' " + CRLF
		cQuery += " AND CT_DOC='MR" + SUBSTR(Dtos(mv_par01),3,4) + "-MO'" + CRLF
	
		MemoWrite("COMRL008XC"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB9',.F.,.T.)
		Count To nRecXC
	
	// MARCA: PROART
	//OR�ADO DE FATURAMENTO - (META SOBRE PERCENTUAIS FIXOS POR SEMANA ???? )
		cQuery := " SELECT SUM(CT_VALOR)/1000 AS TOTAL" + CRLF
		cQuery += " FROM SCT030 SCT WITH(NOLOCK)" + CRLF
		cQuery += " WHERE  " + CRLF
		cQuery += " SCT.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND CT_DOC='MR" + SUBSTR(Dtos(mv_par01),3,4) + "-02'" + CRLF
	
		MemoWrite("COMRL008KC"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB9K',.F.,.T.)
		Count To nRecKC
	//------------------------------------------------------------------------------------------------------------------//	 
	//---------------------------------------------[FIM OR�ADO FATURAMENTO]---------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 

	//------------------------------------------------------------------------------------------------------------------//	 
	//-----------------------------------------------[PREVISAO DE COMPRAS]----------------------------------------------//
	//---------------------------------------------[PEDIDO DE COMPRA ABERTO]--------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	 
	// PREVISAO DE COMPRAS - BASE PEDIDO DE COMPRAS (SC7)	
	// PEDIDOS DE COMPRA C/ MP EM ABERTO                      A C T I O N
		cQuery := " SELECT C7_DATPRF" + CRLF
		cQuery += "		,(C7_QUANT - C7_QUJE)*" + CRLF
		//cQuery += "		,(C7_QUANT)*" + CRLF
		cQuery += " ISNULL((SELECT TOP 1 (D1_TOTAL+D1_VALIPI+D1_ICMSRET)/D1_QUANT  FROM SD1040 D1 WITH(NOLOCK)INNER JOIN SF4040 F4 WITH(NOLOCK)ON D1_TES = F4_CODIGO WHERE D1_COD = C7_PRODUTO AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N' AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'   AND D1_FILIAL = C7_FILIAL ORDER BY D1_DTDIGIT DESC),C7_PRECO)/1000 TOTAL," + CRLF
		cQuery += " B1_TIPO, (CASE WHEN C7_ITEMCTA = '' THEN B1_ITEMCC ELSE C7_ITEMCTA END) AS C7_ITEMCTA, C7_PO_EIC " + CRLF 
		cQuery += " ,ISNULL((SELECT TOP(1) 'EMBARCADO' FROM SW7040 WITH(NOLOCK) WHERE W7_PO_NUM=C7_PO_EIC AND D_E_L_E_T_='' AND W7_FILIAL=C7_FILIAL AND W7_COD_I=C7_PRODUTO),'') AS SW7_EMBARQUE " + CRLF
		cQuery += " FROM SC7040 C7 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SB1040 B1 WITH(NOLOCK) ON B1_COD = C7_PRODUTO AND B1_FILIAL=C7_FILIAL AND B1.D_E_L_E_T_ <> '*'" + CRLF
		cQuery += " WHERE  C7_FILIAL = '02' " + CRLF
		cQuery += " AND C7_RESIDUO = ' ' " + CRLF
		cQuery += " AND C7_QUJE < C7_QUANT " + CRLF
		cQuery += " AND C7.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND C7_EMISSAO >= '"+Dtos(dDatabase-120)+"'" + CRLF
		
		cQuery += " UNION ALL" + CRLF
		
		// PEDIDOS DE COMPRA C/ MP EM ABERTO             T A I F F P R O A R T 
		cQuery += " SELECT C7_DATPRF" + CRLF
		cQuery += "	,(C7_QUANT - C7_QUJE)*" + CRLF
		//cQuery += "	,(C7_QUANT)*" + CRLF
		cQuery += " ISNULL((SELECT TOP 1 (D1_TOTAL+D1_VALIPI+D1_ICMSRET)/D1_QUANT  FROM SD1030 D1 WITH(NOLOCK)INNER JOIN SF4030 F4 WITH(NOLOCK)ON D1_TES = F4_CODIGO AND F4_FILIAL = D1_FILIAL WHERE D1_COD = C7_PRODUTO AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N' AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'   AND D1_FILIAL = C7_FILIAL ORDER BY D1_DTDIGIT DESC),C7_PRECO)/1000 TOTAL" + CRLF
		cQuery += " ,(CASE WHEN ISNULL(B1.B1_TIPO,'')='' THEN B1_TAIFF.B1_TIPO ELSE B1.B1_TIPO END) AS B1_TIPO" + CRLF
		cQuery += " ,(CASE WHEN C7_ITEMCTA = '' THEN (CASE WHEN ISNULL(B1.B1_ITEMCC,'')='' THEN B1_TAIFF.B1_ITEMCC ELSE B1.B1_ITEMCC END) ELSE C7_ITEMCTA END) AS C7_ITEMCTA" + CRLF
		cQuery += " ,C7_PO_EIC " + CRLF 
		cQuery += " ,ISNULL((SELECT TOP(1) 'EMBARCADO' FROM SW7030 WITH(NOLOCK) WHERE W7_PO_NUM=C7_PO_EIC AND D_E_L_E_T_='' AND W7_FILIAL=C7_FILIAL AND W7_COD_I=C7_PRODUTO),'') AS SW7_EMBARQUE " + CRLF
		cQuery += " FROM SC7030 C7 WITH(NOLOCK)" + CRLF
		cQuery += " LEFT OUTER JOIN SB1010 B1 WITH(NOLOCK) ON B1.B1_COD = C7_PRODUTO" + CRLF
		cQuery += " AND B1.D_E_L_E_T_ <> '*'" + CRLF
		cQuery += " LEFT OUTER JOIN SB1030 B1_TAIFF WITH(NOLOCK) ON B1_TAIFF.B1_COD = C7_PRODUTO AND C7_FILIAL = B1_TAIFF.B1_FILIAL" + CRLF
		cQuery += " AND B1_TAIFF.D_E_L_E_T_ <> '*'" + CRLF
		cQuery += " WHERE 1=1 " + CRLF
		cQuery += " AND C7_QUJE < C7_QUANT " + CRLF
		cQuery += " AND C7_RESIDUO = ' '  " + CRLF
		cQuery += " AND C7_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " + CRLF
		cQuery += " AND C7.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND C7_EMISSAO >= '"+Dtos(dDatabase-120)+"'" + CRLF
		cQuery += " ORDER BY C7_DATPRF" + CRLF

	
		MemoWrite("COMRL08D"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB4',.F.,.T.)
		Count To nRecD
		TCSETFIELD("TRB4","C7_DATPRF","D")

	//------------------------------------------------------------------------------------------------------------------//	 
	//-----------------------------------------------[PREVISAO DE COMPRAS]----------------------------------------------//
	//------------------------------------------[SC EM ABERTO + SI EM ABERTO]------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//
	// CONSIDERA��ES
	// EM REUNI�O REALIZADA EM 02/05/2017 COM YUJIRO E LEONARDO FOI DEFINIDO QUE MANTERIA-SE A VIS�O CONGELADA DA SC  
	// ISTO � DEVE-SE DESCONSIDERAR A QUANIDADE ENTREGUE OU ELIMINA��O DE RESIDUO
	// A VIS�O SER� DISTRIBUIDA PROPORCIONALMENTE AOS DIAS UTEIS DOS MES 25% ... 25% ... 25% ... 25%   
	//------------------------------------------------------------------------------------------------------------------//
		IF 1=2			 
			// PREVISAO DE COMPRAS - BASE SOLICITA��O DE COMPRAS (SC1)	
			//�����������������������������������������Ŀ
			//�Solicitacao de Compra Periodo Selecionado                  A C  T I O N �
			//�������������������������������������������
			cQuery := " SELECT C1_DATPRF, (C1_QUANT)* " + CRLF
			cQuery += " ISNULL((SELECT TOP 1 (D1_TOTAL+D1_VALIPI+D1_ICMSRET)/D1_QUANT  FROM SD1040 D1 WITH(NOLOCK) INNER JOIN SF4040 F4 WITH(NOLOCK)ON D1_TES = F4_CODIGO WHERE D1_COD = C1_PRODUTO AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N' AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'   AND D1_FILIAL = C1_FILIAL ORDER BY D1_DTDIGIT DESC),B1_UPRC)/1000 TOTAL" + CRLF
			cQuery += " ,'NAC' AS ORIGEM" + CRLF
			cQuery += " ,B1_TIPO" + CRLF
			cQuery += " ,(CASE WHEN C1_ITEMCTA='' THEN B1_ITEMCC ELSE C1_ITEMCTA END) AS C1_ITEMCTA " + CRLF
			cQuery += " FROM SC1040 C1 WITH(NOLOCK)" + CRLF
			cQuery += " INNER JOIN SB1040 B1 WITH(NOLOCK) ON C1_PRODUTO = B1_COD" + CRLF
			cQuery += " WHERE  " + CRLF
			//cQuery += " 	C1_QUJE < C1_QUANT AND C1_RESIDUO = ' ' AND " + CRLF 
			cQuery += " 	C1_TPOP = 'F' " + CRLF
			cQuery += " 	AND C1_FILIAL ='02' AND C1.D_E_L_E_T_ <> '*'  AND B1.D_E_L_E_T_ <> '*'" + CRLF
			cQuery += " 	AND C1_EMISSAO >= '"+Dtos(dDatabase-120)+"'" + CRLF
	
				cQuery += " UNION ALL" + CRLF
	
			//�Solicitacao de Compra Periodo Selecionado          T A I F F P R O A R T   �
			cQuery += " SELECT C1_DATPRF, (C1_QUANT)* " + CRLF
			cQuery += " ISNULL((SELECT TOP 1 (D1_TOTAL+D1_VALIPI+D1_ICMSRET)/D1_QUANT  FROM SD1030 D1 WITH(NOLOCK) INNER JOIN SF4030 F4 WITH(NOLOCK)ON D1_TES = F4_CODIGO AND F4_FILIAL = D1_FILIAL WHERE D1_COD = C1_PRODUTO AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N' AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'   AND D1_FILIAL = C1_FILIAL ORDER BY D1_DTDIGIT DESC),B1_UPRC)/1000 TOTAL" + CRLF
			cQuery += " ,'NAC' AS ORIGEM" + CRLF
			cQuery += " ,B1_TIPO" + CRLF
			cQuery += " ,(CASE WHEN C1_ITEMCTA='' THEN B1_ITEMCC ELSE C1_ITEMCTA END) AS C1_ITEMCTA " + CRLF
			cQuery += " FROM SC1030 C1 WITH(NOLOCK)" + CRLF
			cQuery += " INNER JOIN SB1030 B1 WITH(NOLOCK) ON C1_PRODUTO = B1_COD AND B1_FILIAL = C1_FILIAL" + CRLF
			cQuery += " WHERE  " + CRLF
			//cQuery += " 	C1_QUJE < C1_QUANT AND C1_RESIDUO = ' ' AND " + CRLF
			cQuery += " C1_TPOP = 'F' AND C1_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND C1.D_E_L_E_T_ <> '*'  AND B1.D_E_L_E_T_ <> '*'" + CRLF
			cQuery += " AND C1_EMISSAO >= '"+Dtos(dDatabase-120)+"'" + CRLF
	
				cQuery += " UNION ALL" + CRLF
	
			// SOLICITA��O DE IMPORTA��O (SW1)                  A C T I O N   V A R G I N H A	
			cQuery += "SELECT " + CRLF
			cQuery += "	W1_DTENTR_ AS C1_DATPRF" + CRLF
			cQuery += "	,((W1_QTDE * W1_PRECO)*(SELECT dbo.RET_VALOR_MOEDA('04', W1_FILIAL, YF_MOEFAT,W1_DTENTR_)))/1000 AS TOTAL" + CRLF
			cQuery += "	,'IMP' AS ORIGEM" + CRLF
			cQuery += "	,B1_TIPO" + CRLF
			cQuery += "	,B1_ITEMCC AS C1_ITEMCTA " + CRLF
			cQuery += "FROM SW1040 SW1 WITH(NOLOCK) " + CRLF
			cQuery += "INNER JOIN SW0040 SW0 WITH(NOLOCK)" + CRLF
			cQuery += "	ON W0_FILIAL=W1_FILIAL" + CRLF
			cQuery += "	AND W0__CC=W1_CC" + CRLF
			cQuery += "	AND W0__NUM=W1_SI_NUM " + CRLF
			cQuery += "INNER JOIN SB1040 SB1 WITH(NOLOCK)" + CRLF
			cQuery += "	ON B1_COD=W1_COD_I" + CRLF
			cQuery += "	AND B1_FILIAL=W1_FILIAL" + CRLF
			cQuery += "	AND SB1.D_E_L_E_T_='' " + CRLF
			cQuery += "LEFT OUTER JOIN SYF040 SYF WITH(NOLOCK)" + CRLF
			cQuery += "	ON SYF.D_E_L_E_T_=''" + CRLF
			cQuery += "	AND YF_MOEDA=W0_MOEDA " + CRLF
			cQuery += "WHERE W1_FILIAL='02' " + CRLF
			cQuery += "	AND SW1.D_E_L_E_T_='' " + CRLF
			//cQuery += "	AND W1_SALDO_Q != 0 " + CRLF
			cQuery += "	AND W1_DTENTR_>='"+Dtos(dDatabase-120)+"'" + CRLF

			cQuery += " UNION ALL" + CRLF
		ENDIF
	
		// PREVISAO DE COMPRAS - BASE PURCHASE ORDER (SW3)      A C T I O N   V A R G I N H A	
		// MANTENDO SOBRE A PREVIS�O DE EMBARQUE

		aResult := TCSPEXEC("SP_REL_COMRL008_PREVISAO_IMPORTADO", Dtos(dDatabase-120), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
		dbUseArea( .T., "TOPCONN", aResult[1],"TRB5", .F., .T.)
		TCSETFIELD("TRB5","C1_DATPRF","D")
		Count To nRecE
		
	//------------------------------------------------------------------------------------------------------------------//	 
	//----------------------------------------[FIM DA PREVISAO DE COMPRAS]----------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 

	// NF DEVOLUCAO
		cQuery := " SELECT D1_DTDIGIT,SUM(D1_TOTAL+((D1_TOTAL*D1_IPI)/100)+D1_ICMSRET)/1000 TOTAL_DEV " + CRLF
		cQuery += " FROM "+("SD1"+cNEmpAnt)+" D1 WITH(NOLOCK), "+("SF4"+cNEmpAnt)+" F4 WITH(NOLOCK)" + CRLF
		cQuery += " WHERE D1_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_<> '*' AND D1_TIPO = 'D'" + CRLF
		cQuery += " AND D1_DTDIGIT between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "+Iif(cNEmpAnt=="030"," AND F4_FILIAL = D1_FILIAL","") + CRLF
		cQuery += " AND D1_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " + CRLF
		cQuery += " AND D1_INTER <> 'S' " + CRLF
		cQuery += " GROUP BY D1_DTDIGIT, F4_ESTOQUE" + CRLF
		cQuery += " ORDER BY D1_DTDIGIT, F4_ESTOQUE" + CRLF
		MemoWrite("COMRL008F"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB6',.F.,.T.)
		Count To nRecF
		TCSETFIELD("TRB6","D1_DTDIGIT","D")


	//SALDO EM ESTOQUE
		cQuery := " SELECT (SUM(B2_VATU1))/1000 B2_VATU1, B1_TIPO, B2_LOCAL," + CRLF
		cQuery += " CASE WHEN B2_LOCAL = '31'  THEN" + CRLF
		cQuery += " ISNULL(SUM(B2_QNPT*B2_CM1 )/1000 ,0)" + CRLF
		cQuery += " ELSE" + CRLF
		cQuery += " 0" + CRLF
		cQuery += " END" + CRLF
		cQuery += " B2_QNPT" + CRLF
		//NO FINAL DO MES CALCULA DE TODOS OS DIAS
		If lFim
			cQuery += ", B2_COD" + CRLF
		EndIf
		cQuery += " , CASE WHEN RIGHT(RTRIM(LTRIM(B2_COD)),2)='IP' THEN 'IMP' ELSE 'NAC' END ORIGEM " + CRLF
		cQuery += " , B1_ITEMCC" + CRLF
		cQuery += " FROM SB2040 B2 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SB1040 B1 WITH(NOLOCK) ON B1_COD = B2_COD AND B2_FILIAL = B1_FILIAL" + CRLF
		cQuery += " WHERE B2.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND B2_COD <> ''" + CRLF
		cQuery += " AND B2_LOCAL IN	('01','02','11','21','31','32','51','52','80','81','91','92','93','96')" + CRLF
		cQuery += " AND B2_FILIAL BETWEEN '02' AND '02'" + CRLF
		cQuery += " AND B1_MSBLQL <> '1'" + CRLF
		cQuery += " and B1_TIPO <> 'MO'" + CRLF
		cQuery += " GROUP BY  B1_TIPO,B2_LOCAL, B2_FILIAL, B2_COD, B1_ITEMCC" + CRLF

		cQuery += " UNION ALL" + CRLF
		
		cQuery += " SELECT (SUM(B2_VATU1))/1000 B2_VATU1, B1_TIPO, B2_LOCAL," + CRLF
		cQuery += " CASE WHEN B2_LOCAL = '31'  THEN" + CRLF
		cQuery += " ISNULL(SUM(B2_QNPT*B2_CM1 )/1000 ,0)" + CRLF
		cQuery += " ELSE" + CRLF
		cQuery += " 0" + CRLF
		cQuery += " END" + CRLF
		cQuery += " B2_QNPT" + CRLF
		//NO FINAL DO MES CALCULA DE TODOS OS DIAS
		If lFim
			cQuery += ", B2_COD" + CRLF
		EndIf
		cQuery += " , CASE WHEN RIGHT(RTRIM(LTRIM(B2_COD)),2)='IP' THEN 'IMP' ELSE 'NAC' END ORIGEM " + CRLF
		cQuery += " , B1_ITEMCC" + CRLF
		cQuery += " FROM SB2030 B2 WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SB1010 B1 WITH(NOLOCK) ON B1_COD = B2_COD " + CRLF
		cQuery += " WHERE B2.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND B2_COD <> ''" + CRLF
		cQuery += " AND B2_LOCAL IN ('01','02','11','21','25','51','52','81','91','92','93','96')" + CRLF
		cQuery += " AND B2_FILIAL BETWEEN '01' AND '02'" + CRLF
		cQuery += " AND B1_MSBLQL <> '1'" + CRLF
		cQuery += " and B1_TIPO <> 'MO'" + CRLF
		cQuery += " GROUP BY  B1_TIPO,B2_LOCAL, B2_FILIAL, B2_COD, B1_ITEMCC" + CRLF

		MemoWrite("COMRL008G"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB7',.F.,.T.)
		Count To nRecG
	
	//------------------------------------------------------------------------------------------------------------------//	 
	//------------------------------------------[PROGRAMA�AO DA PRODU��O]-----------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	//PROGRAMA��O DA PRODU��O DADOS OBTIDOS ATRAVES DA TABELA CUSTOMIZADA GERENCIADA POR LEONARDO (COMPRAS NAC+IMP)
		// REGISTRADOS EM PCPPROGA.PRW
		//	CHAPAS: CODFAM={000} .AND. SUBFAM={10,15} 
		//	SECADOR: CODFAM={000} .AND. SUBFAM={00,05}
		cQuery := " SELECT ZAT_QUANT, ZAT_DATA " + CRLF
		cQuery += " ,CASE WHEN B1_CODFAM='000' AND B1_SUBFAM IN ('10','15') THEN 'CHP' WHEN B1_CODFAM='000' AND B1_SUBFAM IN ('00','05') THEN 'SEC' ELSE 'OUT' END AS LINHA" + CRLF
		cQuery += " FROM ZAT040 ZAT WITH(NOLOCK)" + CRLF
		cQuery += " INNER JOIN SB1040 B1 WITH(NOLOCK) " + CRLF
		cQuery += " 	ON B1_COD = ZAT_COD " + CRLF
		cQuery += " 	AND B1_FILIAL = ZAT_FILIAL" + CRLF
		cQuery += " 	AND B1.D_E_L_E_T_ = '' " + CRLF
		cQuery += " 	AND B1_MSBLQL != '1'" + CRLF
		cQuery += " 	AND B1_TIPO = 'PA'" + CRLF
		cQuery += " INNER JOIN ZA2010 ZA2 WITH(NOLOCK)" + CRLF
		cQuery += " 	ON ZA2_CODFAM=B1_CODFAM" + CRLF
		cQuery += " 	AND ZA2_CODSUB=B1_SUBFAM" + CRLF
		cQuery += " 	AND ZA2.D_E_L_E_T_ = ''" + CRLF
 		cQuery += " WHERE ZAT_DATA between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " + CRLF
		cQuery += " AND ZAT.D_E_L_E_T_ = '' "  + CRLF
		cQuery += " AND ZAT.ZAT_FILIAL = '02' " + CRLF
		cQuery += " AND ('TAIFF' = '" + CMARCA + "' OR ''= '" + CMARCA + "') "+ CRLF
		cQuery += " ORDER BY ZAT_DATA, LINHA"  + CRLF
		MemoWrite("COMRL008HA"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB8A',.F.,.T.)
		Count To nRecHA
		TCSETFIELD("TRB8A","ZAT_DATA","D")	
	
	//------------------------------------------------------------------------------------------------------------------//	 
	//----------------------------------------[FIM PROGRAMA�AO DA PRODU��O]---------------------------------------------//
	//------------------------------------------------------------------------------------------------------------------//	 
	//PRODUCAO ENCERRADA
		cQuery := " SELECT SUM(D3_CUSTO1)/1000 AS D3_CUSTO1 ,  SUM(D3_QUANT) D3_QUANT, D3_EMISSAO "
		cQuery += " ,CASE WHEN B1_CODFAM='000' AND B1_SUBFAM IN ('10','15') THEN 'CHP' WHEN B1_CODFAM='000' AND B1_SUBFAM IN ('00','05') THEN 'SEC' ELSE 'OUT' END AS LINHA" + CRLF
		cQuery += " FROM SD3040 D3 WITH(NOLOCK)"
		cQuery += " INNER JOIN "+("SB1"+cNEmpAnt)+" B1 WITH(NOLOCK) ON B1_COD = D3_COD AND B1_FILIAL = D3_FILIAL"
		cQuery += " WHERE D3_ESTORNO = '' AND D3_FILIAL  ='02' "
		cQuery += " AND D3_OP <> ''"
		cQuery += " AND D3_EMISSAO between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
		cQuery += " AND B1.D_E_L_E_T_ <> '*' AND D3.D_E_L_E_T_ <> '*'"
		cQuery += " AND B1_MSBLQL <> '1'"
		cQuery += " AND D3_TM = '03' AND B1_TIPO = 'PA'"
		cQuery += " GROUP BY D3_EMISSAO,B1_CODFAM,B1_SUBFAM" 
		MemoWrite("COMRL008H"+cNEmpAnt+".SQL",cQuery)
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB8',.F.,.T.)
		Count To nRecH
		TCSETFIELD("TRB8","D3_EMISSAO","D")
	
		dbSelectArea("SM0")
	
		If !lWeb
		//PRIMEIRA REGUA
			nPRO ++
			oObj:SetRegua1(MAXPASSO)
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Notas de Entrada"
			oObj:SetRegua2(nRecA)
		EndIf
	
	//MONTA ARRAY COM OS CAMPOS A SEREM IMPRESSOS
		If kk == 1
			aAtu	:= {} //{01-DATA, 02-DIA SEM, 03-COMPRAS IMP, 04-COMPRAS PROD, 05-COMPRAS ACUM, 06-FAT TAIFF, 07-FAT PROART, 08-FAT SEM USO, 09-PEDVEN TAIFF, 10-PEDVEN PROART, 11-PEDVEN SEM USO, 12-PREV COMPRAS MP, 13- PREV COMPRAS IMP, 14- PREV COMPRAS SOLC, 15-PREV COMPRAS ACUM,16-ESTOQUE MP, 17- ETOQUE PA, 18- ESTOQUE ACUMULADO, 19- ESTOQUE CHAPA, 20 - ESTOQUE SECADOR, 21- ESTOQUE PA ACUMULADO, 22- ESTOQUE MP ASS.TEC., 23- QTDE PROD CHAPA, 24- QTDE PROD SECADOR, 25- QTDE PROD ACUMULADO}
		
		//CARREGA O ARRAY COM OS DIAS DO MES
			nDias := (mv_par02-mv_par01)
			nMes  := Month(mv_par01)+1	//ARMAZENA O PROXIMO MES
																  //                   10                  20                  30
																  // 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
			aAdd(aAtu,{mv_par01,SubStr(DiaSemana(mv_par01),1,3),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
			For n:=1 To nDias                                        // 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
				aAdd(aAtu,{mv_par01+n,SubStr(DiaSemana(mv_par01+n),1,3),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
			Next
		EndIf
	
	//NOTAS DE ENTRADA
		If nRecA > 0
			dbSelectArea("TRB1")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				Z:= aScan(aAtu,{|x| x[1]==TRB1->D1_DTDIGIT })
				
				// D1_ORIGEM - indica a origem do produto Importado ou Nacional
				// D1_ITEMCTA - indica a marca se PROART ou TAIFF 
			//VERIFICA A NOTA
				If TRB1->D1_ITEMCTA=CMARCA .OR. (EMPTY(CMARCA) .AND. ALLTRIM(TRB1->D1_ITEMCTA) $ "TAIFF|PROART")
					If TRB1->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. .NOT. EMPTY(TRB1->F1_HAWB)  //PRODUTO MP(I) 
						aAtu[Z][3] += TRB1->TOTAL_MP
					ElseIf TRB1->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. EMPTY(TRB1->F1_HAWB)  //PRODUTO MP(N)
						aAtu[Z][4] += TRB1->TOTAL_MP
					ElseIf TRB1->B1_TIPO $ "PA" .AND. .NOT. EMPTY(TRB1->F1_HAWB) //PRODUTO PA(I)
						aAtu[Z][5] += TRB1->TOTAL_MP
					EndIf
				EndIf
				dbSkip()
			End
		EndIf
		TRB1->(dbCloseArea())
	
		If !lWeb
		//SEGUNDA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Notas de Saida"
			oObj:SetRegua2(nRecB)
		EndIf
	
	//NOTAS DE SAIDA
	//CASO NAO TENHA NOTAS GRAVA ARRAY EM BRANCO
	
		If nRecB > 0
			dbSelectArea("TRB2")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				Z:= aScan(aAtu,{|x| x[1]==TRB2->D2_EMISSAO })
			//VERIFICA A NOTA
			
				If AllTrim(TRB2->D2_ITEMCC) == "TAIFF" .AND. (CMARCA = AllTrim(TRB2->D2_ITEMCC) .OR. EMPTY(CMARCA)) .AND. TRB2->D2_SERIE='1' 
					aAtu[Z][6] += TRB2->TOTAL_FAT
				ElseIf AllTrim(TRB2->D2_ITEMCC) == "TAIFF" .AND. (CMARCA = AllTrim(TRB2->D2_ITEMCC) .OR. EMPTY(CMARCA)) .AND. TRB2->D2_SERIE='3'	// ASTEC
					aAtu[Z][7] += TRB2->TOTAL_FAT
				ElseIf AllTrim(TRB2->D2_ITEMCC) == "PROART" .AND. CMARCA = AllTrim(TRB2->D2_ITEMCC) .AND. TRB2->D2_SERIE='2'		//PROART
					aAtu[Z][6] += TRB2->TOTAL_FAT
				ElseIf AllTrim(TRB2->D2_ITEMCC) == "PROART" .AND. (CMARCA = AllTrim(TRB2->D2_ITEMCC) .OR. EMPTY(CMARCA)) .AND. TRB2->D2_SERIE='3'		// ASTEC
					aAtu[Z][7] += TRB2->TOTAL_FAT
				ElseIf AllTrim(TRB2->D2_ITEMCC) == "PROART" .AND. EMPTY(CMARCA) .AND. TRB2->D2_SERIE='2'		//PROART
					aAtu[Z][33] += TRB2->TOTAL_FAT
				EndIf
			
				dbSkip()
			End
		EndIf
		TRB2->(dbCloseArea())
	
		If !lWeb
		//TERCEIRA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Pedidos de Vendas"
			oObj:SetRegua2(nRecC)
		EndIf
	/*
	//PEDIDOS DE VENDAS  
		If nRecC > 0 
			dbSelectArea("TRB3")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
			
			
				If TRB3->C6_ENTREG < mv_par03 //MES ANTERIOR
				
					If AllTrim(TRB3->C6_XITEMC) == "TAIFF"
						nPedVWAnt += TRB3->TOTAL
					Else //PROART
						nPedVSAnt += TRB3->TOTAL
					EndIf
				
				
				
				ElseIf TRB3->C6_ENTREG >= mv_par03 .And. TRB3->C6_ENTREG <= mv_par04  //MES SELECIONADO
					Z:= aScan(aAtu,{|x| x[1]==TRB3->C6_ENTREG })
				
					If AllTrim(TRB3->C6_XITEMC) == "TAIFF"
						aAtu[Z][9] += TRB3->TOTAL
					Else //PROART
						aAtu[Z][10] += TRB3->TOTAL
					EndIf
				Else			//PROXIMOS MESES
				
					If AllTrim(TRB3->C6_XITEMC) == "TAIFF"
						Iif(Month(TRB3->C6_ENTREG)== nMes,nPedVWPos += TRB3->TOTAL ,nPedVWsPos += TRB3->TOTAL)
					Else //PROART
						Iif(Month(TRB3->C6_ENTREG)== nMes,nPedVSPos += TRB3->TOTAL ,nPedVSsPos += TRB3->TOTAL)
					EndIf
				EndIf
				dbSkip()
			End
		EndIf
		TRB3->(dbCloseArea())
	*/
	
	//PREVISAO DE VENDAS SOBRE AS METAS COM VIS�O SEMANAL - 1a sem 15% - 2a sem 20% - 3a sem 25% - 4a sem 40%
		If nRecC > 0 .AND. (CMARCA="TAIFF" .OR. Empty(CMARCA)) 
			TRB3->(DbGoTop())
			dUltSemana := mv_par03
			nTrb3Cont 	:= 0 
			For nTrb3Loop:= 1 TO 4
				While .T.
					nTrb3Cont += 1				
					dUltSemana += 1				
					If DOW(dUltSemana) = 6 
						If nTrb3Loop=1 .AND. nTrb3Cont < 3
						Else
							Exit
						EndIf   
					EndIf	
				EndDo 
				Z:= aScan(aAtu,{|x| x[1] == dUltSemana })
				aAtu[Z][9] := (TRB3->TOTAL * aSEMPER[nTrb3Loop]) / 100
			Next

		EndIf
		TRB3->(dbCloseArea())

		If !lWeb
		//QUARTA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Pedidos de Compras"
			oObj:SetRegua2(nRecD)
		EndIf

	//PREVISAO DE VENDAS SOBRE AS METAS DA ASTEC COM VIS�O SEMANAL - 1a sem 25% - 2a sem 25% - 3a sem 25% - 4a sem 25%
		If nRecXC > 0 .AND. (CMARCA="TAIFF" .OR. Empty(CMARCA))
			TRB9->(DbGoTop())
			dUltSemana := mv_par03
			nTrb3Cont 	:= 0 
			For nTrb3Loop:= 1 TO 4
				While .T.
					nTrb3Cont += 1				
					dUltSemana += 1				
					If DOW(dUltSemana) = 6 
						If nTrb3Loop=1 .AND. nTrb3Cont < 3
						Else
							Exit
						EndIf   
					EndIf	
				EndDo 
				Z:= aScan(aAtu,{|x| x[1] == dUltSemana })
				aAtu[Z][10] := (TRB9->TOTAL * 25) / 100
			Next

		EndIf
		TRB9->(dbCloseArea())
	
	//PREVISAO DE VENDAS SOBRE AS METAS DA PROART COM VIS�O SEMANAL - 1a sem 25% - 2a sem 25% - 3a sem 25% - 4a sem 25%
		If nRecKC > 0 .AND. (CMARCA="PROART")
			TRB9K->(DbGoTop())
			dUltSemana := mv_par03 
			nTrb3Cont 	:= 0 
			For nTrb3Loop:= 1 TO 4
				While .T.
					nTrb3Cont += 1				
					dUltSemana += 1				
					If DOW(dUltSemana) = 6 
						If nTrb3Loop=1 .AND. nTrb3Cont < 3
						Else
							Exit
						EndIf   
					EndIf	
				EndDo 
				Z:= aScan(aAtu,{|x| x[1] == dUltSemana })
				aAtu[Z][9] := (TRB9K->TOTAL * 25) / 100
			Next

		EndIf
		If nRecKC > 0 .AND. Empty(CMARCA)
			TRB9K->(DbGoTop())
			dUltSemana := mv_par03 
			nTrb3Cont 	:= 0 
			For nTrb3Loop:= 1 TO 4
				While .T.
					nTrb3Cont += 1				
					dUltSemana += 1				
					If DOW(dUltSemana) = 6 
						If nTrb3Loop=1 .AND. nTrb3Cont < 3
						Else
							Exit
						EndIf   
					EndIf	
				EndDo 
				Z:= aScan(aAtu,{|x| x[1] == dUltSemana })
				aAtu[Z][32] := (TRB9K->TOTAL * 25) / 100
				nDias += 7 
			Next

		EndIf
		TRB9K->(dbCloseArea())

		//PEDIDO DE COMPRAS
		NTRB5MPI := 0
		NTRB5MPN := 0
		NTRB5PAI := 0
		If nRecD > 0            

			dbSelectArea("TRB4")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				If TRB4->C7_ITEMCTA = CMARCA .or. (Empty(CMARCA) .AND. ALLTRIM(TRB4->C7_ITEMCTA) $ "TAIFF|PROART")
					If TRB4->C7_DATPRF < mv_par01
						If TRB4->B1_TIPO $ "PA|MP|BN|PB|ET|EM|PI|MO|RT|MA" //PRODUTO 
							nPedCPAnt += TRB4->TOTAL
						Else
							nPedCSAnt += TRB4->TOTAL
						EndIf
					ElseIf TRB4->C7_DATPRF >= mv_par01 .And. TRB4->C7_DATPRF <= mv_par02
						Z:= aScan(aAtu,{|x| x[1]==TRB4->C7_DATPRF })
						If TRB4->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. .NOT. EMPTY(TRB4->C7_PO_EIC) .AND. TRB4->SW7_EMBARQUE="EMARCADO" //MP PRODUTO IMPORTADO
							//aAtu[Z][12] += TRB4->TOTAL
							NTRB5MPI += TRB4->TOTAL
						ElseIf TRB4->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. EMPTY(TRB4->C7_PO_EIC) //MP PRODUTO NACIONAL
							//aAtu[Z][13] += TRB4->TOTAL
							NTRB5MPN += TRB4->TOTAL
						ElseIf TRB4->B1_TIPO $ "PA|PR" .AND. .NOT. EMPTY(TRB4->C7_PO_EIC) .AND. TRB4->SW7_EMBARQUE="EMARCADO" //PA PRODUTO IMPORTADO
							//aAtu[Z][14] += TRB4->TOTAL
							NTRB5PAI += TRB4->TOTAL
						EndIf
					Else
						If TRB4->B1_TIPO $ "PA|MP|BN|PB|ET|EM|PI|MO|RT|MA"  //PRODUTO
							Iif(Month(TRB4->C7_DATPRF)==nMes, nPedCPPos += TRB4->TOTAL,nPedCPsPos += TRB4->TOTAL)
						Else
							Iif(Month(TRB4->C7_DATPRF)==nMes, nPedCSPos += TRB4->TOTAL,nPedCSsPos += TRB4->TOTAL)
						EndIf
					
					EndIf
				EndIf
				dbSkip()
			End
		EndIf
		TRB4->(dbCloseArea())
	
		If !lWeb
		//QUINTA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Solicita��o de Compras"
			oObj:SetRegua2(nRecE)
		EndIf
	
		//SOLICITACAO DE COMPRAS + SI (SW0)
		If nRecE > 0        
			
			dbSelectArea("TRB5")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				If TRB5->C1_ITEMCTA = CMARCA .or. (Empty(CMARCA) .AND. ALLTRIM(TRB5->C1_ITEMCTA) $ "TAIFF|PROART")
					If TRB5->C1_DATPRF < mv_par01
						nSolAnt += TRB5->TOTAL
					ElseIf TRB5->C1_DATPRF >= mv_par01 .And. TRB5->C1_DATPRF <= mv_par02
						Z:= aScan(aAtu,{|x| x[1]==TRB5->C1_DATPRF })
						If TRB5->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. TRB5->ORIGEM="IMP"  //MP PRODUTO IMPORTADO
							//aAtu[Z][12] += TRB5->TOTAL
							NTRB5MPI += TRB5->TOTAL
						ElseIf TRB5->B1_TIPO $ "MP|BN|PB|ET|EM|PI|MO|RT|MA" .AND. TRB5->ORIGEM="NAC"  //MP PRODUTO NACIONAL
							//aAtu[Z][13] += TRB5->TOTAL
							NTRB5MPN += TRB5->TOTAL
						ElseIf TRB5->B1_TIPO $ "PA" .AND. TRB5->ORIGEM="IMP" //PA PRODUTO IMPORTADO
							//aAtu[Z][14] += TRB5->TOTAL
							NTRB5PAI += TRB5->TOTAL
						EndIf
					Else
						Iif(Month(TRB5->C1_DATPRF)==nMes,nSolPos += TRB5->TOTAL,nSolsPos += TRB5->TOTAL)
					EndIf
				EndIf
				dbSkip()
			End
			
		EndIf
		TRB5->(dbCloseArea())

		If (NTRB5MPI + NTRB5MPN + NTRB5PAI) > 0
			dUltSemana := mv_par03 
			nTrb3Cont 	:= 0 
			For nTrb3Loop:= 1 TO 4
				While .T.
					nTrb3Cont += 1				
					dUltSemana += 1				
					If DOW(dUltSemana) = 6 
						If nTrb3Loop=1 .AND. nTrb3Cont < 3
						Else
							Exit
						EndIf   
					EndIf	
				EndDo 

				Z:= aScan(aAtu,{|x| x[1] == dUltSemana })
				aAtu[Z][12] := (NTRB5MPI * 25) / 100
				aAtu[Z][13] := (NTRB5MPN * 25) / 100
				aAtu[Z][14] := (NTRB5PAI * 25) / 100

			Next
		EndIf


		If !lWeb
		//SEXTA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Notas devolu��o Vendas"
			oObj:SetRegua2(nRecE)
		EndIf

	//NOTAS DEVOLUCAO VENDAS
		If nRecF > 0
			dbSelectArea("TRB6")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				nNFDev += TRB6->TOTAL_DEV
				dbSkip()
			End
		EndIf
		TRB6->(dbCloseArea())


		If !lWeb
		//SETIMA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando Saldos em estoque"
			oObj:SetRegua2(nRecE)
		EndIf

	//SALDO EM ESTOQUE
		If nRecG > 0
			dbSelectArea("TRB7")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf
				//NO FINAL DO MES CALCULA DE TODOS OS DIAS
				If lFim
					/*
					Sintaxe
					CalcEst(cProduto, cAlmox, dData)
					Par�metros
					cProduto - Produto a ser pesquisado
					cAlmox - Almoxarifado a pesquisar
					dData - Data desejada
					Retorna
					aArray - Array contendo:
					Elemento 1 - Quantidade inicial em estoque na data
					Elemento 2 - Custo inicial na data na moeda 1
					Elemento 3 - Custo inicial na data na moeda 2
					Elemento 4 - Custo inicial na data na moeda 3
					Elemento 5 - Custo inicial na data na moeda 4
					Elemento 6 - Custo inicial na data na moeda 5
					Elemento 7 - Quantidade inicial na segunda unidade de medida
					Exemplos
					aSaldos:=CalcEst(SB1->B1_COD,SB1->B1_LOCPAD, dDataBase)
					nQuant:=aSaldos[1]
					*/
					For Z:=1 To Len(aAtu)
						aSaldos:=CalcEst(TRB7->B2_COD,TRB7->B2_LOCAL, dData)
						If aSaldos[1]>0
							If TRB7->B2_LOCAL $ "51|52|" //ASSISTENCIA TECNICA
								aAtu[Z][22] += (aSaldos[1]*aSaldos[2])/1000
							ElseIf TRB7->B1_TIPO $ "PA|PR|" //PRODUTO ACABADO
								aAtu[Z][17] += (aSaldos[1]*aSaldos[2])/1000
							Else
								aAtu[Z][16] += (aSaldos[1]*aSaldos[2])/1000
							EndIf
						EndIf
					Next
				Else
					If TRB7->B1_ITEMCC = CMARCA .or. (Empty(CMARCA) .AND. ALLTRIM(TRB7->B1_ITEMCC) $ "TAIFF|PROART")
						Z:= aScan(aAtu,{|x| x[1]== dData })
						If TRB7->B2_LOCAL $ "51|52|" //ASSISTENCIA TECNICA
							aAtu[Z][22] += TRB7->B2_VATU1
							aAtu[Z][29] += TRB7->B2_QNPT
						ElseIf TRB7->B1_TIPO $ "PA|PR|" .AND. TRB7->ORIGEM="NAC" //PRODUTO ACABADO
							aAtu[Z][17] += TRB7->B2_VATU1
							aAtu[Z][29] += TRB7->B2_QNPT
						ElseIf TRB7->B1_TIPO $ "PA|PR|" .AND. TRB7->ORIGEM="IMP" //PRODUTO ACABADO
							aAtu[Z][30] += TRB7->B2_VATU1
							aAtu[Z][29] += TRB7->B2_QNPT
						ElseIf TRB7->ORIGEM="NAC"
							aAtu[Z][16] += TRB7->B2_VATU1
							aAtu[Z][29] += TRB7->B2_QNPT
						ElseIf TRB7->ORIGEM="IMP"
							aAtu[Z][31] += TRB7->B2_VATU1
							aAtu[Z][29] += TRB7->B2_QNPT
						EndIf
					EndIf
				EndIf
				dbSkip()
			End
		EndIf
		
		TRB7->(dbCloseArea())

		If !lWeb
		//OITAVA REGUA
			nPRO ++
			oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
		
			cMensagem := "Selecionando OPs finalizadas"
			oObj:SetRegua2(nRecE)
		EndIf

		If nRecH > 0
			dbSelectArea("TRB8")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf

				Z:= aScan(aAtu,{|x| x[1]==TRB8->D3_EMISSAO })

				If AllTrim(TRB8->LINHA) == "SEC" //SECADOR
					aAtu[Z][20]  += TRB8->D3_CUSTO1 //VALOR
					aAtu[Z][24]  += TRB8->D3_QUANT //QTDE
				ElseIf AllTrim(TRB8->LINHA) == "CHP" //CHAPA
					aAtu[Z][19]  += TRB8->D3_CUSTO1  //VALOR
					aAtu[Z][23]  += TRB8->D3_QUANT //QTDE
				Else
					aAtu[Z][21]  += TRB8->D3_CUSTO1
					aAtu[Z][25]  += TRB8->D3_QUANT //ACUMULADO QTDE
				EndIf

				dbSkip()
			End
		EndIf
		TRB8->(dbCloseArea())
		If nRecHA > 0
			dbSelectArea("TRB8A")
			dbGoTop()
			While !EOF()
				If !lWeb
					oObj:IncRegua2(cMensagem)
				EndIf

				Z:= aScan(aAtu,{|x| x[1]==TRB8A->ZAT_DATA })

				If AllTrim(TRB8A->LINHA) == "SEC" //SECADOR
					aAtu[Z][26]  += TRB8A->ZAT_QUANT //QTDE
				ElseIf AllTrim(TRB8A->LINHA) == "CHP" //CHAPA
					aAtu[Z][27]  += TRB8A->ZAT_QUANT //QTDE
				Else
					aAtu[Z][28]  += TRB8A->ZAT_QUANT //QTDE
				EndIf

				dbSkip()
			End
		EndIf
		TRB8A->(dbCloseArea())
	
	Next

	IMPDET(Cabec1,Cabec2,Cabec3,Titulo,nLin)

	If Len(aResult) > 0
		//Exclui a tabela temporaria do Banco de Dados
		If TcCanOpen(aResult[1])
			TcSqlExec("DROP TABLE "+aResult[1])
		EndIf
	EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpDet    �Autor  �Microsiga           � Data �  03/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime os Detalhes do Relatorio                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpDet(Cabec1,Cabec2,Cabec3,Titulo,nLin)
	Local nT1	:= 0
	Local nT2	:= 0
	Local nT3	:= 0
	Local nT4	:= 0
	Local nT5	:= 0
	Local nT6	:= 0
	Local nT7	:= 0
	Local nT7x	:= 0
	Local nT8	:= 0
	Local nT8x	:= 0
	Local nTotA	:= 0
	Local nTotB	:= 0
	Local nTotC	:= 0
	Local nTotD	:= 0
	Local nTotE	:= 0
	Local nTotF	:= 0
	Local nTotG	:= 0
	Local nTotH	:= 0
	Local nTotI	:= 0
	Local nTotJ	:= 0
	Local nTotK	:= 0
	Local nTotL	:= 0
	Local nTotM	:= 0
	Local nTotN	:= 0
	Local nTotO	:= 0		
	Local cArqu	:= "COMRL008"+cEmpSch+"_"+cEmpSch+".##r"
	Local cDir
	Local a		:= 0

Local aDriver := ReadDriver()

	If lWeb
		cDir	:= "\SPOOL\"//"\Relato\"
	Else
		cDir	:= AllTrim(PswRet()[2][3])
	EndIf

	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

		nRow := PRow()
		nCol := PCol()
		SetPrc(0,0)
		nLin := 0
		@ 0,000 PSAY AvalImp(132)                            
		@ 0,000 PSAY &(aDriver[5])
		@ 0,000 PSAY "" 
	 
		@ nLin,001 psay "." 
		nLin++
		@ nLin,001 psay "SIGA - " + nomeprog 
		@ nLin,nQtCol - 30  psay "Emissao: " + DTOC(DATE()) + " " + TIME() + &(aDriver[5])
		nLin++
		@ nLin,001 psay REPLICATE("-",nQtCol) + &(aDriver[5])
		nLin++
		@ nLin,001 psay "|"
		@ nLin,nQtCol psay "|"
		nLin++
		@ nLin,001 psay "|"
		@ nLin,(132) - Len(Titulo) psay Titulo 	+ &(aDriver[5])
		@ nLin,nQtCol psay "|"
		nLin++
		@ nLin,001 psay "|"
		@ nLin,nQtCol psay "|"
		nLin++
		@ nLin,001 psay REPLICATE("-",nQtCol) + &(aDriver[5])
		nLin++
		@ nLin,001 psay IIF(CMARCA="TAIFF",Cabec1,IIF(CMARCA="PROART",PCabec1,GCabec1)) 	
		nLin++
		@ nLin,001 psay IIF(CMARCA="TAIFF",Cabec2,IIF(CMARCA="PROART",PCabec2,GCabec2))	
		nLin++
		//nLin := 8
		//NliN++

	Endif
	/*
	If !lWeb
	//SEXTA REGUA
		nPRO ++
		oObj:IncRegua1(cTEXT+AllTrim(Str(nPRO))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
	
		cMensagem := "Imprimindo Relatorio"
		oObj:SetRegua2(Len(aAtu))
	EndIf
	*/

	@ nLin,001 psay IIF(CMARCA="TAIFF",Cabec3,IIF(CMARCA="PROART",PCabec3,GCabec3))
	nLin++
	//@ nLin,001 psay "         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22"
	//nLin++
	//@ nLin,001 psay "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" 
	//nLin++
	@ nLin,001 psay REPLICATE("-",nQtCol)  
	//@ nLin,001 psay __prtthinline()
	nLin++
	for a := 1 to Len(aAtu)
		If !lWeb
			oObj:IncRegua2(cMensagem)
		EndIf
	
		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			nLin++
			@ nLin,001 psay Cabec3
			nLin++
		Endif
//aAtu	:= {} //{01-DATA, 02-DIA SEM, 03-COMPRAS IMP, 04-COMPRAS PROD, 05-COMPRAS ACUM, 06-FAT TAIFF, 07-FAT PROART, 08-FAT SEM USO, 09-PEDVEN TAIFF, 10-PEDVEN PROART, 11-PEDVEN SEM USO, 12-PREV COMPRAS MP, 13- PREV COMPRAS IMP, 14- PREV COMPRAS SOLC, 15-PREV COMPRAS ACUM,16-ESTOQUE MP, 17- ETOQUE PA, 18- ESTOQUE ACUMULADO, 19- ESTOQUE CHAPA, 20 - ESTOQUE SECADOR, 21- ESTOQUE PA ACUMULADO, 22- ESTOQUE MP ASS.TEC.}
	
		nT1 += aAtu[a][3]+aAtu[a][4]+aAtu[a][5] 	//ACUMULADO NFE
		nT2 += aAtu[a][6]+aAtu[a][7]+aAtu[a][8]+aAtu[a][33]	//ACUMULADO NFS
		nT3 += aAtu[a][9]+aAtu[a][10]+aAtu[a][11]+aAtu[a][32]	//ACUMULADO PEDIDO VENDAS
		nT4 += aAtu[a][12]+aAtu[a][13]+aAtu[a][14]	//ACUMULADO PEDIDO COMPRAS + SOLICITACAO
		nT5 := aAtu[a][17]+aAtu[a][16]+aAtu[a][22]	//ACUMULADO ESTOQUE DIARIO
		nT6 += aAtu[a][20]+aAtu[a][19]				//ACUMULADO PRODUCAO VALOR
		//nT7 += aAtu[a][23]+aAtu[a][24]+aAtu[a][25]	//ACUMULADO PRODUCAO QTDE
		nT7x += aAtu[a][24]	//ACUMULADO PRODUCAO QTDE
		nT7 += aAtu[a][23]	//ACUMULADO PRODUCAO QTDE


		//nT8 += aAtu[a][26]+aAtu[a][27]+aAtu[a][28]	//ACUMULADO PRODUCAO QTDE
		nT8x += aAtu[a][26]	//ACUMULADO PRODUCAO QTDE
		nT8 += aAtu[a][27]
				
		nTotA += aAtu[a][3]		//TOTAL NFE - PRODUTO
		nTotB += aAtu[a][4]		//TOTAL NFE - IMPRODUTIVO
		nTotC += aAtu[a][6]		//TOTAL NFS - TAIFF
		nTotD += aAtu[a][7]		//TOTAL NFS - PROART
		nTotE += aAtu[a][8]		//TOTAL NFS - SEM USO
		nTotF += aAtu[a][9]		//TOTAL PEDIDO VENDA - TAIFF
		nTotG += aAtu[a][10]	//TOTAL PEDIDO VENDA - PROART
		nTotH += aAtu[a][11]	//TOTAL PEDIDO VENDA - SEM USO
		nTotI += aAtu[a][12]	//TOTAL PEDIDO COMPRAS - MATERIA PRIMA
		nTotJ += aAtu[a][13]	//TOTAL PEDIDO COMPRAS - IMPRODUTIVO
		nTotK += aAtu[a][14]	//TOTAL SOLICITACAO COMPRAS
		nTotL += aAtu[a][20]	//TOTAL FABRICADO SECADOR VALOR
		nTotM += aAtu[a][19]	//TOTAL FABRICADO CHAPA VALOR
		nTotN += aAtu[a][24]	//TOTAL FABRICADO SECADOR QTDE
		nTotO += aAtu[a][23]	//TOTAL FABRICADO CHAPA QTDE

//GCabec1      := "                  P R E V.  F A T U R A M.     |        F A T U R A M E N T O      | ESTOQUE | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |     E S T O Q U E     |"
//GCabec2      := "              Taiff    ProArt    ASTEC         |   Taiff   ProArt    ASTEC         | R E A L |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |    R    E    A    L   |"
//GCabec3      := "Dia           Valor    Valor     Valor    Acum.|   Valor    Valor    Valor    Acum.| PA(N+I) |   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os. |"
//             "            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220       230       240       250       260       270 
//             "  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//                 99/99/99 SEG 99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999     99,999   99,999   99,999   99,999   99,999   99,999   99,999  99,999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999

		 	
//Cabec1      := "             P R E V.  F A T U R A M. |  F A T U R A M E N T O   | ESTOQUE | P R E V I S A O    C O M P R A S  |            C O M P R A S          |             E S T O Q U E             |     E S T O Q U E     |   PROGRAMA��O DA PRODUCAO     |   P R O D U C A O   R E A L   |"
//Cabec2      := "               Taiff    ASTEC         |   Taiff    ASTEC         | R E A L |   MP(I)    MP(N)    PA(I)         |   MP(I)    MP(N)    PA(I)         |            O  R  �  A  D  O           |    R    E    A    L   |    Sec             Chp        |    Sec             Chp        |"
//Cabec3       := "Dia           Valor    Valor    Acum.|   Valor    Valor    Acum.| PA(N+I) |   Valor    Valor    Valor    Acum.|   Valor    Valor    Valor    Acum.|  MP(I)   MP(N)   3os.    PA(N)   PA(I)|  MP(I)   MP(N)   3os. |  Quant   Acum.   Quant   Acum.|  Quant   Acum.   Quant   Acum.|"
//             "            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220       230       240       250       260       270 
//             "  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//                 99/99/99 SEG 99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999   99,999  999,999   99,999   99,999   99,999   99,999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999  999999

		@ nLin,001 PSAY aAtu[a][1] 						//DATA
		@ nLin,010 PSAY aAtu[a][2] 						//DIA DA SEMANA
		If Empty(CMARCA)
			@ nLin,014 PSAY aAtu[a][9] 	Picture "@E 99,999"	//PEDIDO VENDA - TAIFF
			@ nLin,023 PSAY aAtu[a][32]	Picture "@E 99,999"	//PEDIDO VENDA - PROART
			@ nLin,032 PSAY aAtu[a][10]	Picture "@E 99,999"	//PEDIDO VENDA - ASTEC
			@ nLin,041 PSAY nT3 			Picture "@E 99,999"	//ACUMULADO PEDIDO VENDA
			@ nLin,048 PSAY "|"

			@ nLin,050 PSAY aAtu[a][6] 	Picture "@E 99,999"		//NFS - TAIFF
			@ nLin,059 PSAY aAtu[a][33]	Picture "@E 99,999"		//NFS - PROART
			@ nLin,068 PSAY aAtu[a][7] 	Picture "@E 99,999"		//NFS - ASTEC
			@ nLin,077 PSAY nT2 			Picture "@E 99,999"		// ACUMULADO NFS
			@ nLin,084 PSAY "|"

			@ nLin,086 PSAY aAtu[a][17] + aAtu[a][22] + aAtu[a][30]  Picture "@E 99,999"		//SALDO ESTOQUE PA(n+i)
			@ nLin,094 PSAY "|"

			// previsao de compras
			@ nLin,097 PSAY aAtu[a][12]	Picture "@E 99,999"		//PEDIDO + SC COMPRAS ABERTO 
			@ nLin,106 PSAY aAtu[a][13]	Picture "@E 99,999"		
			@ nLin,115 PSAY aAtu[a][14]	Picture "@E 99,999"		
			@ nLin,123 PSAY nT4 			Picture "@E 999,999"		
			@ nLin,130 PSAY "|"
			// compras realizado
			@ nLin,133 PSAY aAtu[a][3]	Picture "@E 99,999"		//MP - IMPORTADO
			@ nLin,142 PSAY aAtu[a][4] 	Picture "@E 99,999"      //MP - NACIONAL
			@ nLin,151 PSAY aAtu[a][5]	Picture "@E 99,999"		//PA - IMPORTADO
			@ nLin,159 PSAY nT1 			Picture "@E 99,999"		//ACUMULADO NFE
			@ nLin,166 PSAY "|"
			// estoque or�ado
			//		
			@ nLin,206 PSAY "|"

			// estoque real
			@ nLin,207 PSAY aAtu[a][16] Picture "@E 99,999"		//SALDO ESTOQUE MP(i)
			@ nLin,215 PSAY aAtu[a][31] Picture "@E 99,999"		//SALDO ESTOQUE MP(n)
			@ nLin,223 PSAY aAtu[a][29] Picture "@E 99,999"		//SALDO ESTOQUE 3os	
			@ nLin,230 PSAY "|"

		Else
			@ nLin,014 PSAY aAtu[a][9] 	Picture "@E 99,999"	//PEDIDO VENDA - TAIFF
			@ nLin,023 PSAY aAtu[a][10]	Picture "@E 99,999"	//PEDIDO VENDA - ASTEC
			@ nLin,032 PSAY nT3 			Picture "@E 99,999"	//ACUMULADO PEDIDO VENDA
			@ nLin,038 PSAY "|"
		
			@ nLin,041 PSAY aAtu[a][6] 	Picture "@E 99,999"		//NFS - TAIFF
			@ nLin,050 PSAY aAtu[a][7] 	Picture "@E 99,999"		//NFS - PROART
			@ nLin,059 PSAY nT2 			Picture "@E 99,999"		// ACUMULADO NFS
			@ nLin,065 PSAY "|"
	
			@ nLin,068 PSAY aAtu[a][17] + aAtu[a][22] + aAtu[a][30]  Picture "@E 99,999"		//SALDO ESTOQUE PA(n+i)
			@ nLin,075 PSAY "|"
	
			// previsao de compras
			@ nLin,077 PSAY aAtu[a][12]	Picture "@E 99,999"		//PEDIDO + SC COMPRAS ABERTO 
			@ nLin,086 PSAY aAtu[a][13]	Picture "@E 99,999"		
			@ nLin,095 PSAY aAtu[a][14]	Picture "@E 99,999"		
			@ nLin,103 PSAY nT4 			Picture "@E 999,999"		
			@ nLin,111 PSAY "|"
			
			// compras realizado
			@ nLin,113 PSAY aAtu[a][3]	Picture "@E 99,999"		//MP - IMPORTADO
			@ nLin,122 PSAY aAtu[a][4] 	Picture "@E 99,999"      //MP - NACIONAL
			@ nLin,131 PSAY aAtu[a][5]	Picture "@E 99,999"		//PA - IMPORTADO
			@ nLin,140 PSAY nT1 			Picture "@E 99,999"		//ACUMULADO NFE
			@ nLin,147 PSAY "|"
			// estoque or�ado
			//		
			@ nLin,187 PSAY "|"
			
			// estoque real
			@ nLin,188 PSAY aAtu[a][16] Picture "@E 99,999"		//SALDO ESTOQUE MP(i)
			@ nLin,196 PSAY aAtu[a][31] Picture "@E 99,999"		//SALDO ESTOQUE MP(n)
			@ nLin,204 PSAY aAtu[a][29] Picture "@E 99,999"		//SALDO ESTOQUE 3os	
			@ nLin,211 PSAY "|"
			
			If CMARCA="TAIFF"
				// programa��o da produ��o	
				@ nLin,212 PSAY aAtu[a][26]	Picture "@E 9999999"		//QTDE PRODUZIDO SECADOR
				@ nLin,220 PSAY nT8x			Picture "@E 9999999"		//QTDE ACUMULADO PRODUZIDO SECADOR 
				@ nLin,228 PSAY aAtu[a][27]	Picture "@E 9999999"		//QTDE PRODUZIDO CHAPA
				@ nLin,236 PSAY nT8			Picture "@E 9999999"		//QTDE ACUMULADO PRODUZIDO CHAPA
				@ nLin,243 PSAY "|"
		
				@ nLin,244 PSAY aAtu[a][24]	Picture "@E 9999999"		//QTDE PRODUZIDO SECADOR
				@ nLin,252 PSAY nT7x			Picture "@E 9999999"		//QTDE ACUMULADO PRODUZIDO SECADOR
				@ nLin,260 PSAY aAtu[a][23]	Picture "@E 9999999"		//QTDE PRODUZIDO CHAPA 
				@ nLin,268 PSAY nT7 			Picture "@E 9999999"		//QTDE ACUMULADO PRODUZIDO CHAPA 
				@ nLin,275 PSAY "|"
			EndIf
		EndIf
						
		nLin ++ // Avanca a linha de impressao
	
	next
//caso seja web e necessario colocar duas linhas para imrpmir o html correto
	If !lWeb
		Y:= 1
	Else
		Y:= 2
	EndIf
	nLin+=y
	//@ nLin,001 PSAY __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y

/*
	@ nLin,001 PSAY "TOTAL: " Picture "@!"

	@ nLin,010 PSAY nTotI Picture "@E 99,999"
	@ nLin,016 PSAY "(A)" Picture "@!"
	
	@ nLin,019 PSAY nTotJ Picture "@E 99,999"
	@ nLin,025 PSAY "(B)" Picture "@!"
	
	@ nLin,028 PSAY nTotK Picture "@E 99,999"
	@ nLin,034 PSAY "(C)" Picture "@!"


	@ nLin,047 PSAY nTotA Picture "@E 99,999"
	@ nLin,053 PSAY "(D)" Picture "@!"
	@ nLin,056 PSAY nTotB Picture "@E 99,999"
	@ nLin,062 PSAY "(F)" Picture "@!"


	@ nLin,074 PSAY nTotF Picture "@E 99,999"
	@ nLin,080 PSAY "(G)" Picture "@!"
	@ nLin,083 PSAY nTotG Picture "@E 99,999"
	@ nLin,089 PSAY "(I)" Picture "@!"
	

	@ nLin,101 PSAY nTotC Picture "@E 99,999"
	@ nLin,107 PSAY "(J)" Picture "@!"
	@ nLin,110 PSAY nTotD Picture "@E 99,999"
	@ nLin,116 PSAY "(K)" Picture "@!"


	@ nLin,164 PSAY nTotL Picture "@E 99,999"
	@ nLin,170 PSAY "(L)" Picture "@!"

	@ nLin,173 PSAY nTotM Picture "@E 99,999"
	@ nLin,179 PSAY "(M)" Picture "@!"

	@ nLin,191 PSAY nTotN Picture "@E 9999999"
	@ nLin,197 PSAY "(N)" Picture "@!"

	@ nLin,200 PSAY nTotO Picture "@E 9999999"
	@ nLin,206 PSAY "(O)" Picture "@!"

	
	nLin+=Y
	@ nLin,101 PSAY nNFDev Picture "@E 99,999"
	@ nLin,107 PSAY "(E - DEVOLUCOES)" Picture "@!"
	

	nLin+=y
	//@ nLin,001 PSAY __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y

	@ nLin,001 PSAY "TOTAL GERAL: "
	@ nLin,020 PSAY nTotI + nTotJ + nTotK Picture "@E 99,999"
	@ nLin,026 PSAY "(A+B+C)" picture "@!"

	@ nLin,047 PSAY nTotA+nTotB Picture "@E 99,999"
	@ nLin,053 PSAY "(D+F)" picture "@!"

	@ nLin,074 PSAY nTotF+nTotG Picture "@E 99,999"
	@ nLin,080 PSAY "(G+I)" picture "@!"

	@ nLin,110 PSAY nTotC+nTotD-nNFDev Picture "@E 99,999"
	@ nLin,116 PSAY "(J+K-E)" picture "@!"

	@ nLin,173 PSAY nTotL + nTotM Picture "@E 99,999"
	@ nLin,179 PSAY "(L+M)" picture "@!"

	@ nLin,200 PSAY nTotN + nTotO Picture "@E 999999"
	@ nLin,206 PSAY "(N+O)" picture "@!"

	nLin+=y
	//@ nLin,001 PSAY __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y

	@ nLin,001 PSAY "TOTAL COMPRAS PRODUT.: " + Transform((nTotA+nTotI),"@E 99,999")+" (A+D)"
	@ nLin,076 PSAY "TOTAL FATURAMENTO TAIFF   : " + Transform((nTotC+nTotF),"@E 99,999")+" (G+J)"
	nLin+=y
	@ nLin,001 PSAY "              IMPROD.: " + Transform((nTotB+nTotJ),"@E 99,999") + " (B+F)(+)"
	@ nLin,076 PSAY "                   PROART: " + Transform(nTotD+nTotG,"@E 99,999") + " (I+K)(+)"
	nLin+=y
	@ nLin,024 PSAY "-----------------------"
	@ nLin,104 PSAY "-----------------------"
	nLin+=y
	@ nLin,001 PSAY "COMPRAS TOTAL GERAL:   " + Transform((nTotA+nTotI+nTotB+nTotJ),"@E 99,999") + " (A+B+D+F)(=)"
	@ nLin,076 PSAY "FATURAMENTO TOTAL GERAL:   " + Transform(nTotC+nTotE+nTotF+nTotH+nTotD+nTotG-nNFDev,"@E 99,999") + " (G+I+J+K-E)(=)"

	nLin+=y
	//@ nLin,001 psay __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y
	@ nLin,001 psay "Sld.Ant.: "
	@ nLin,013 psay nPedCPAnt picture "@E 99,999"  	//PEDIDO DE COMPRAS PRODUTO ANTERIOR
	@ nLin,022 psay nPedCSAnt picture "@E 99,999"	//PEDIDO DE COMPRAS IMPRODUTIVO ANTERIOR
	@ nLin,031 psay nSolAnt	  picture "@E 99,999"	//SOLICITACAO DE COMPRAS ANTERIOR
	@ nLin,077 psay nPedVWAnt picture "@E 99,999" 	//PEDIDO DE VENDAS TAIFF ANTERIOR
	@ nLin,086 psay nPedVSAnt picture "@E 99,999" 	//PEDIDO DE VENDAS PROART ANTERIOR
	
	nLin+=y
	@ nLin,016 psay "(=)"
	@ nLin,024 psay (nPedCPAnt+nPedCSAnt + nSolAnt) picture "@E 99,999"
	@ nLin,096 psay "(=)"
	@ nLin,104 psay (nPedVPAnt+nPedVSAnt+nPedVWAnt) picture "@E 99,999"



	nLin+=y
	//@ nLin,001 psay __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y
	@ nLin,001 psay "Prox.Mes: "
	@ nLin,013 psay nPedCPPos picture "@E 99,999"  	//PEDIDO DE COMPRAS PRODUTO POSTERIOR
	@ nLin,022 psay nPedCSPos picture "@E 99,999"	//PEDIDO DE COMPRAS SERVICO POSTERIOR
	@ nLin,031 psay nSolPos	  picture "@E 99,999"	//SOLICITACAO DE COMPRAS POSTERIOR
	@ nLin,077 psay nPedVWPos picture "@E 99,999"	//PEDIDO DE VENDAS TAIFF POSTERIOR
	@ nLin,086 psay nPedVSPos picture "@E 99,999"	//PEDIDO DE VENDAS PROART POSTERIOR


	nLin+=y
	@ nLin,016 psay "(=)"
	@ nLin,024 psay nPedCPPos + nPedCSPos + nSolPos picture "@E 99,999"
	@ nLin,096 psay "(=)"
	@ nLin,104 psay nPedVPPos + nPedVSPos + nPedVWPos picture "@E 99,999"

	nLin+=y
	//@ nLin,001 psay __prtthinline()
	@ nLin,001 psay REPLICATE("-",nQtCol)
	nLin+=y
	@ nLin,001 psay "Sld.Post.: "
	@ nLin,013 psay nPedCPsPos picture "@E 99,999"	//PEDIDOS COMPRAS PRODUTOS PARA O MES SUBSEQUENTE
	@ nLin,022 psay nPedCSsPos picture "@E 99,999"	//PEDIDOS COMPRAS SERVICOS PARA O MES SUBSEQUENTE
	@ nLin,031 psay nSolsPos   picture "@E 99,999"	//SOLICITACAO DE COMPRAS PARA O MES SUBSEQUENTE
	@ nLin,077 psay nPedVSsPos picture "@E 99,999"	//PEDIDOS VENDAS PROART PARA O MES SUBSEQUENTE
	@ nLin,086 psay nPedVWsPos picture "@E 99,999"	//PEDIDOS VENDAS TAIFF PARA O MES SUBSEQUENTE


	nLin+=y
	@ nLin,016 psay "(=)"
	@ nLin,024 psay nPedCPsPos + nPedCSsPos + nSolsPos picture "@E 99,999"
	@ nLin,096 psay "(=)"
	@ nLin,104 psay nPedVPsPos + nPedVSsPos + nPedVWsPos picture "@E 99,999"

	nLin+=y
	@ nLin,001 psay REPLICATE("-",nQtCol)
	//@ nLin,001 psay __prtthinline()
*/

	SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		If !lWeb
			OurSpool(wnrel)
		Endif
	EndIf


	MS_FLUSH()
	If lWeb
		cTitulo := Titulo
	//	cDescri  := "Segue relatorio de Valores"
		cDescri  := "Segue relatorio de Valores "
		cDestina := cEmailAdm
		cMens    := "Parametros usados:"+"  -> Venda de: "+Dtoc(mv_par01)+" Venda At�: "+Dtoc(mv_par02)+"     -> Fat. De: "+Dtoc(mv_par03)+" Fat. At�: "+Dtoc(mv_par04)
		cArquivo := cDir+cArqu
		If File(cArquivo)
			Conout("Modificando Arquivo")
			ENVEmail(cDir,cArqu,cDestina,cTitulo,cDescri,cMens)
		EndIf
		Ferase(cArquivo)
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �FERNANDA            � Data �  21/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �FAZ O TRATAMENTO NO ARQUIVO E ENVIA POR EMAIL               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ENVEmail(cDir,cArqu,cDestina,cTitulo,cDescri,cMens)

	//Local oDlg
	Local cNewFile
	Local cFileToSend
	//Local lCopy := .F.
	Local nHdl := -1
	//Local lSend := .T.
	Local lRename :=.F.

	cTitle 	:= cTitulo
	cDesc 	:= cDescri
	cDirAtu := cDir
	cArquivo:= cArqu
//copia o arquivo .##R para .TXT
	cArquivo := cDirAtu+cArquivo
	If File(cArquivo)
		cFileToSend := Subs(cArquivo,1,At(".",cArquivo))+"TXT"
		If lRename
			cNewFile := cArquivo
			nHdl := 1
		Else
			cNewFile := Subs(cArquivo,1,At(".",cArquivo))+".TMP"
			__CopyFile(cArquivo,cNewFile)
			nHdl := If(File(cNewFile),1,-1)
		EndIf
		cHtmNewFile:=Subs(cArquivo,1,At(".",cArquivo))+"Htm"
	Else
		cNewFile := cArquivo
		nHdl := -1
	EndIf
	If RmvToken(cNewFile,cFileToSend)
		U_MsL008Html( cFileToSend , cHtmNewFile )
		CONOUT("Enviando Email")
		//U_L008ENVMAIL('pedidos@actionmotors.com.br',"carlos.torres@taiffproart.com.br;yujiro.kenmochi@taiffproart.com.br;leonardo.lima@taiffproart.com.br",'',cDesc,cTitle ,cHtmNewFile)
		U_L008ENVMAIL('pedidos@actionmotors.com.br',"carlos.torres@taiff.com.br",'',cDesc,cTitle ,cHtmNewFile)
	EndIf
	Ferase(cNewFile)
	Ferase(cFileToSend)
	Ferase(cHtmNewFile)

RETURN NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Paulo Bindo         � Data �  12/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria pergunta no e o help do SX1                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg(p1)

	// Local cKey := ""
	// Local aHelpEng := {}
	// Local aHelpPor := {}
	// Local aHelpSpa := {}


//PutSx1(cGrupo,cOrdem,cPergunt            ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  			,cDefSpa2,cDefEng2,cDef03	,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Data Compras De   ?",""                    ,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par01",""		,""      ,""      ,""    ,""					,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Data Compras Ate  ?",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par02",""        ,""      ,""      ,""    ,""      				,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Data Faturam. De  ?",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par03",""    	,""      ,""      ,""    ,""      				,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Data Faturam. Ate ?",""                    ,""                    ,"mv_ch4","D"   ,08      ,0       ,0      , "C",""    ,"" ,""         ,""   ,"mv_par04",""		,""      ,""      ,""    ,""					,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Filial de         ?",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "C",""    ,"SM0" ,""         ,""   ,"mv_par05",""		,""      ,""      ,""    ,""					,""     ,""      ,""		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Filial Ate        ?",""                    ,""                    ,"mv_ch6","C"   ,02      ,0       ,0      , "G",""    ,"SM0" ,""         ,""   ,"mv_par06",""		,""      ,""      ,""    ,""					,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


/*
cKey     := "P.FTRL0301."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Selecione se quer emitir um or�a-    ")
aAdd(aHelpPor,"mento ou um Pedido.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0302."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o n�mero inicial do pedido ou    ")
aAdd(aHelpPor,"do or�amento.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0303."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o n�mero Final do pedido ou    ")
aAdd(aHelpPor,"do or�amento.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0304."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Selecione se ir� imprimir")
aAdd(aHelpPor,"os pedidos novos ou re-imprimir")
aAdd(aHelpPor,"um pedido")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0305."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Selecione se ir� imprimir")
aAdd(aHelpPor,"os pedidos de Contrato")
aAdd(aHelpPor,"Spot ou Ambos")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0306."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a data inicial")
aAdd(aHelpPor,"de entrega dos pedidos")
aAdd(aHelpPor,"Somente para re-impressao")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0307."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a data final")
aAdd(aHelpPor,"de entrega dos pedidos")
aAdd(aHelpPor,"Somente para re-impressao")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0308."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe se a separa��o")
aAdd(aHelpPor,"ser� por Onda ou por")
aAdd(aHelpPor,"Pedido")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.FTRL0309."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Selecione um contrato")
aAdd(aHelpPor,"ou deixe em branco para ")
aAdd(aHelpPor,"Imprimir todos!")
aAdd(aHelpPor,"Funciona somente para ")
aAdd(aHelpPor,"Separa��o por Onda")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
*/
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnvMail   �Autor  �Microsiga           � Data �  07/23/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



//������������������������������������Ŀ
//�cVar1 - conta de email no campo FROM�
//�cVar2 - conta de email no campo TO  �
//�cVar3                               �
//�cVar4 - Mensagem do corpo do email  �
//�cVar5 - titullo do email            �
//�cVar6 - endereco do anexo           �
//��������������������������������������


User Function L008ENVMAIL(cVar1,cVar2,cVar3,cVar4,cVar5,cVar6)

	Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
	Local cTitulo1	:= Rtrim(cVar5)
	Local cEmailTo	:= Rtrim(cVar2)
	Local cEmailBcc:= ""
	Local cError   := ""
	Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	Local lRet	   := .F.
	Local cFrom	   := GetMV("MV_RELFROM")
	Local cConta   := GetMV("MV_RELACNT")
	Local cSenhaa  := GetMV("MV_RELPSW")
	Local cMensagem	:= cVar4
	Local cAttachment := cVar6



//����������������������������������������Ŀ
//� Tenta conexao com o servidor de E-Mail �
//������������������������������������������
	CONNECT SMTP                         ;
		SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	RESULT   lResult             	// Resultado da tentativa de conex�o

// Se a conexao com o SMPT esta ok
	If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaa)
		Else
			lRet := .T.
		Endif
	
		If lRet
			SEND MAIL FROM 	cFrom ;
				TO 				cEmailTo;
				BCC     		cEmailBcc;
				SUBJECT 		cTitulo1;
				BODY 			cMensagem;
				ATTACHMENT cAttachment;
				RESULT lResult
		
		
			If !lResult
				Conout("Erro no envio do email"+FunName())
				GET MAIL ERROR cError
				Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)
			Endif
		EndIf
		DISCONNECT SMTP SERVER
	Else
	//Erro na conexao com o SMTP Server
		Conout("Erro de conexao SMPT"+FunName())
		GET MAIL ERROR cError
		Help(" ",1,"Atencao",,cError,4,5)
	Endif
Return(lResult)


/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �MsRelToHtml      �Autor�Marinaldo de Jesus� Data �06/07/2006�
�����������������������������������������������������������������������Ĵ
�Descri��o �Converte Arquivo de Relatorio do SIGA em HTML               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico  	                                                �
�������������������������������������������������������������������������/*/
User Function MsL008Html( cMsRelFile , cHtmNewFile )

	Local aMsRelFile

	Local nfhHtmlFile



	Begin Sequence

		DEFAULT cMsRelFile 	:= ""
		DEFAULT cHtmNewFile	:= ( FileNoExt( cMsRelFile ) + ".html" )

		IF !File( cMsRelFile )
			Break
		EndIF

		aMsRelFile	:= FileToArr( cMsRelFile )

		nfhHtmlFile	:= fCreate( cHtmNewFile )
		IF ( nfhHtmlFile < 0 )
			Break
		EndIF

		fWrite( @nfhHtmlFile , "<!-- saved from url=(0022)http://internet.e-mail -->" + CRLF )
		fWrite( @nfhHtmlFile , "<html>" + CRLF )
		fWrite( @nfhHtmlFile , "	<head>" + CRLF )
		fWrite( @nfhHtmlFile , "		<script>" + CRLF )
		fWrite( @nfhHtmlFile , "			var CourierIni	= 10" + CRLF )
		fWrite( @nfhHtmlFile , "			var ArialIni 	= 10" + CRLF )
		fWrite( @nfhHtmlFile , "			var CourierAtu	= 10" + CRLF )
		fWrite( @nfhHtmlFile , "			var ArialAtu	= 10" + CRLF )
		fWrite( @nfhHtmlFile , "			function Zoom(ZoomIn)" + CRLF )
		fWrite( @nfhHtmlFile , "			{" + CRLF )
		fWrite( @nfhHtmlFile , "				var i" + CRLF )
		fWrite( @nfhHtmlFile , "				var id" + CRLF )
		fWrite( @nfhHtmlFile , "				var zoom = -5" + CRLF )
		fWrite( @nfhHtmlFile , "				var objArial" + CRLF )
		fWrite( @nfhHtmlFile , "				var objCourier" + CRLF )
		fWrite( @nfhHtmlFile , "				var obj" + CRLF )
		fWrite( @nfhHtmlFile , "				if (ZoomIn)" + CRLF )
		fWrite( @nfhHtmlFile , "				{" + CRLF )
		fWrite( @nfhHtmlFile , "					if (CourierAtu + 5 > CourierIni + 15)" + CRLF )
		fWrite( @nfhHtmlFile , "					{" + CRLF )
		fWrite( @nfhHtmlFile , "						zoom = 0;" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "					else" + CRLF )
		fWrite( @nfhHtmlFile , "					{" + CRLF )
		fWrite( @nfhHtmlFile , "						zoom = 5;" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "				}" + CRLF )
		fWrite( @nfhHtmlFile , "				CourierAtu = CourierAtu + zoom" + CRLF )
		fWrite( @nfhHtmlFile , "				ArialAtu = ArialAtu + zoom" + CRLF )
		fWrite( @nfhHtmlFile , "				if (CourierAtu < CourierIni)" + CRLF )
		fWrite( @nfhHtmlFile , "				{" + CRLF )
		fWrite( @nfhHtmlFile , "					CourierAtu = CourierIni;" + CRLF )
		fWrite( @nfhHtmlFile , "				}" + CRLF )
		fWrite( @nfhHtmlFile , "				if (ArialAtu < ArialIni)" + CRLF )
		fWrite( @nfhHtmlFile , "				{" + CRLF )
		fWrite( @nfhHtmlFile , "					ArialAtu = ArialIni;" + CRLF )
		fWrite( @nfhHtmlFile , "				}" + CRLF )
		fWrite( @nfhHtmlFile , "				objArial = document.getElementsByName('colArial')" + CRLF )
		fWrite( @nfhHtmlFile , "				objCourier = document.getElementsByName('colCourier')" + CRLF )
		fWrite( @nfhHtmlFile , "				if (objArial.length == 0 && objCourier.length == 0)" + CRLF )
		fWrite( @nfhHtmlFile , "				{" + CRLF )
		fWrite( @nfhHtmlFile , "					obj = document.getElementsByTagName('td')" + CRLF )
		fWrite( @nfhHtmlFile , "					for (i = 0; i < obj.length; i++)" + CRLF )
		fWrite( @nfhHtmlFile , "					{" + CRLF )
		fWrite( @nfhHtmlFile , "						id = obj[i].id;" + CRLF )
		fWrite( @nfhHtmlFile , "						if (id == 'colArial')" + CRLF )
		fWrite( @nfhHtmlFile , "						{" + CRLF )
		fWrite( @nfhHtmlFile , "							obj[i].style.fontSize = ArialAtu+'px';" + CRLF )
		fWrite( @nfhHtmlFile , "						}" + CRLF )
		fWrite( @nfhHtmlFile , "						else if (id == 'colCourier')" + CRLF )
		fWrite( @nfhHtmlFile , "						{" + CRLF )
		fWrite( @nfhHtmlFile , "							obj[i].style.fontSize = CourierAtu+'px';" + CRLF )
		fWrite( @nfhHtmlFile , "						}" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "				}" + CRLF )
		fWrite( @nfhHtmlFile , "				else" + CRLF )
		fWrite( @nfhHtmlFile , "				{" + CRLF )
		fWrite( @nfhHtmlFile , "					for (i = 0; i < objArial.length; i++)" + CRLF )
		fWrite( @nfhHtmlFile , "					{" + CRLF )
		fWrite( @nfhHtmlFile , "						objArial[i].style.fontSize = ArialAtu+'px';" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "					for (i = 0; i < objCourier.length; i++)" + CRLF )
		fWrite( @nfhHtmlFile , "					{" + CRLF )
		fWrite( @nfhHtmlFile , "						objCourier[i].style.fontSize = CourierAtu+'px';" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "				}" + CRLF )
		fWrite( @nfhHtmlFile , "			}" + CRLF )
		fWrite( @nfhHtmlFile , "		</script>" + CRLF )
		fWrite( @nfhHtmlFile , "		<style type='text/css' media='print'>" + CRLF )
		fWrite( @nfhHtmlFile , "			<!--" + CRLF )
		fWrite( @nfhHtmlFile , "					.pagebreak	{" + CRLF )
		fWrite( @nfhHtmlFile , "									page-break-after:always;" + CRLF )
		fWrite( @nfhHtmlFile , "								}" + CRLF )
		fWrite( @nfhHtmlFile , "					.noprint	{" + CRLF )
		fWrite( @nfhHtmlFile , "									display:none;" + CRLF )
		fWrite( @nfhHtmlFile , "								}" + CRLF )
		fWrite( @nfhHtmlFile , "			-->" + CRLF )
		fWrite( @nfhHtmlFile , "		</style>" + CRLF )
		fWrite( @nfhHtmlFile , "		<style type='text/css'>" + CRLF )
		fWrite( @nfhHtmlFile , "			<!--" + CRLF )
		fWrite( @nfhHtmlFile , "				a	{" + CRLF )
		fWrite( @nfhHtmlFile , "						FONT-SIZE: 11px; FONT-FAMILY: Arial; COLOR: black; TEXT-DECORATION: none; }" + CRLF )
		fWrite( @nfhHtmlFile , "					}" + CRLF )
		fWrite( @nfhHtmlFile , "			-->" + CRLF )
		fWrite( @nfhHtmlFile , "		</style>" + CRLF )
		fWrite( @nfhHtmlFile , "		<title>" + CRLF )
		fWrite( @nfhHtmlFile , 			"" + CRLF )
		fWrite( @nfhHtmlFile , "		</title>" + CRLF )
		fWrite( @nfhHtmlFile , "	</head>" + CRLF )
		fWrite( @nfhHtmlFile , "	<body>" + CRLF )
		fWrite( @nfhHtmlFile , "		<table border='0' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF' width='900'>" + CRLF )
		DetToHtml( @aMsRelFile , @nfhHtmlFile )
		fWrite( @nfhHtmlFile , "		</table>" + CRLF )
		fWrite( @nfhHtmlFile , "	</body>" + CRLF )
		fWrite( @nfhHtmlFile , "</html>" + CRLF )

		fClose( nfhHtmlFile )

	End Sequence

Return( cHtmNewFile )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �DetToHtml        �Autor�Marinaldo de Jesus� Data �06/07/2006�
�����������������������������������������������������������������������Ĵ
�Descri��o �Converte Arquivo de Relatorio do SIGA em HTML               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �MsRelToHtml      											�
�������������������������������������������������������������������������/*/
Static Function DetToHtml( aMsRelFile , nfhHtmlFile )

	Local cLine
	Local cByte
	Local cNewLine

	Local lChkByte

	Local nAsc
	Local nPage := 0
	Local nLoop
	Local nLoops
	Local nByte
	Local nBytes

	IF ( Type( cEmpAnt ) == "U" )
		Private cEmpAnt := "99"
	EndIF

	IF ( Type( cFilAnt ) == "U" )
		Private cFilAnt := "01"
	EndIF

	nLoops := Len( aMsRelFile )
	For nLoop := 1 To nLoops
	
		cLine	:= aMsRelFile[ nLoop ]
		nAsc	:= Asc( cLine )
		IF ( nAsc == 13 )
			Loop
		EndIF
	
		IF (;
				( nAsc == 8 );
				.or.;
				( nAsc == 12 );
				)
		
			IF ( nLoop == 1 )
				nPage := 1
			Else
				++nPage
				IF ( nAsc == 12 )
					fWrite( @nfhHtmlFile , "		<div class='pagebreak'></div>" + CRLF )
				EndIF
			EndIF
		
			fWrite( @nfhHtmlFile , "		<div class='noprint'>" + CRLF )
			fWrite( @nfhHtmlFile , "			<a href='javascript:Zoom(true)'>Zoom In</a>" + CRLF )
			fWrite( @nfhHtmlFile , "			&nbsp;&nbsp;" + CRLF )
			fWrite( @nfhHtmlFile , "			<a href='javascript:Zoom(false)'>Zoom Out</a>" + CRLF )
			fWrite( @nfhHtmlFile , "			&nbsp;&nbsp;" + CRLF )
			fWrite( @nfhHtmlFile , "			<a name='page" +StrZero( nPage , 4 )+"'></a>" + CRLF )
			fWrite( @nfhHtmlFile , "		</div>" + CRLF )
		
		ElseIF ( nAsc == 42 )
		
			IF ( "LGRL.BMP" $ cLine )
				cLine := StrTran( cLine , "LGRL.BMP" , Space( Len( "LGRL.BMP" ) ) )
			ElseIF ( "LGRL"+cEmpAnt+".BMP" $ cLine )
				cLine := StrTran( cLine , "LGRL"+cEmpAnt+".BMP" , Space( Len( "LGRL"+cEmpAnt+".BMP" ) ) )
			ElseIF ( "LGRL"+cEmpAnt+cFilAnt+".BMP" $ cLine )
				cLine := StrTran( cLine , "LGRL"+cEmpAnt+cFilAnt+".BMP" , Space( Len( "LGRL"+cEmpAnt+cFilAnt+".BMP" ) ) )
			EndIF
		
			While (;
					!Empty(cLine);
					.and.;
					!ChkAsc( Substr( cLine , 1 , 1 ) , .F. );
					)
				cLine	:= Substr( cLine , 2 )
			End While
		
			nByte		:= 0
			nBytes		:= Len( cLine )
			cNewLine	:= ""
			While ( ( ++nByte ) <= nBytes )
				cByte		:= Substr( cLine , nByte , 1 )
				lChkByte	:= ( Empty( cByte ) .or. ChkAsc( cByte , .F. ) )
				IF ( lChkByte )
					cNewLine += cByte
				Else
					cNewLine += " "
				EndIF
			End While
		
			cLine	:= cNewLine
		
			IF Empty( cLine )
			
				fWrite( @nfhHtmlFile , "<br>" + CRLF )
			
			Else
			
				cLine	:= StrTran( cLine , " " , "&nbsp;" )
				fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
				fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
				fWrite( @nfhHtmlFile , "								<td id='colArial' colspan='3'><hr color='#000000' noshade size='2'></td>" + CRLF )
				fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
				fWrite( @nfhHtmlFile , "								<td id='colArial'>" + cLine + CRLF )
				fWrite( @nfhHtmlFile , "								</td>" + CRLF )
				fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				fWrite( @nfhHtmlFile , "						</table>" + CRLF )
			
			EndIF
		
		ElseIF ( nAsc == 27 )
		
			cLine := Substr( cLine , 4 )
		
			IF ( SubStr( cLine , 1 , 1 ) == "*" )
			
				fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
				fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
				fWrite( @nfhHtmlFile , "								<td id='colArial' colspan='3'><hr color='#000000' noshade size='1'>" + CRLF )
				fWrite( @nfhHtmlFile , "								</td>" + CRLF )
				fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				fWrite( @nfhHtmlFile , "						</table>" + CRLF )
			
			Else
			
				nByte		:= 0
				nBytes		:= Len( cLine )
				cNewLine	:= ""
				While ( ( ++nByte ) <= nBytes )
					cByte		:= Substr( cLine , nByte , 1 )
					lChkByte	:= ( Empty( cByte ) .or. ChkAsc( cByte , .F. ) )
					IF ( lChkByte )
						cNewLine += cByte
					Else
						cNewLine += " "
					EndIF
				End While
			
				cLine	:= StrTran( cNewLine , " " , "&nbsp;" )
				fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
				fWrite( @nfhHtmlFile , "							<tr style='FONT-SIZE: 8px; FONT-FAMILY: Courier New'>" + CRLF )
				fWrite( @nfhHtmlFile , "								<td id='colCourier' colspan='3' nowrap>" + cLine + CRLF )
				fWrite( @nfhHtmlFile , "								</td>" + CRLF )
				fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				fWrite( @nfhHtmlFile , "						</table>" + CRLF )
			
			EndIF
		
		Else
		
			lBr	:= .F.
		
			fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
		
			For nLoop := nLoop To nLoops
			
				cLine	:= aMsRelFile[ nLoop ]
				nAsc	:= Asc( cLine )
			
				IF (;
						( nAsc == 08 );
						.or.;
						( nAsc == 12 );
						.or.;
						( nAsc == 13 );
						.or.;
						( nAsc == 27 );
						.or.;
						( nAsc == 42 );
						)
					--nLoop
					Exit
				EndIF
			
				IF Empty( cLine )
				
					fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
					fWrite( @nfhHtmlFile , "							<br>" + CRLF )
					fWrite( @nfhHtmlFile , "						</table>" + CRLF )
				
					lBr	:= .T.
				
				Else
				
					cLine	:= StrTran( cLine , " " , "&nbsp;" )
					IF ( lBr )
						fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
					EndIF
				
					fWrite( @nfhHtmlFile , "							<tr style='FONT-SIZE: 8px; FONT-FAMILY: Courier New'>" + CRLF )
					fWrite( @nfhHtmlFile , "								<td id='colCourier' nowrap>" + CRLF )
					fWrite( @nfhHtmlFile , cLine + CRLF )
					fWrite( @nfhHtmlFile , "								</td>" + CRLF )
					fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				
					IF ( lBr )
						fWrite( @nfhHtmlFile , "						</table>" + CRLF )
					EndIF
				
					lBr	:= .F.
				
				EndIF
			
				aMsRelFile[ nLoop ] := NIL
			
			Next nLoop
		
			fWrite( @nfhHtmlFile , "						</table>" + CRLF )
		
		EndIF
	
		If nLoop > nLoops
			nLoop := nLoops
		EndIf
	
		aMsRelFile[ nLoop ] := NIL
	
	
	Next nLoop

Return( NIL )

/*
Static Function CABEC008(Titulo ,Cabec1 ,Cabec2 ,Cabec3 ,NomeProg ,Tamanho,nTipo)
*/
Static Function CABEC008(cTitulo,cCabec1,cCabec2,cCabec3,cNomeProg,nTamanho,nChar)
Local nCentro := 0
Local lWin    := .f.
Local aDriver := ReadDriver()

nLargura:=Iif(nTamanho=="P",80,Iif(nTamanho=="G",220,132))
Set Device To Printer

DEFAULT lFirst := .t.
If TYPE("__DRIVER") == "C"
	If "DEFAULT"$__DRIVER
		lWin := .t.
	EndIf
EndIf

If lFirst       
   nRow := PRow()
   nCol := PCol()
   SetPrc(0,0)
	If aReturn[5] <> IMP_SPOOL // Se n�o for via Windows manda os caracteres para setar a impressora
		If nChar == NIL .and. !lWin .and. __cInternet == Nil
			@ 0,0 PSAY &(If(nTamanho=="P",aDriver[1],If(nTamanho=="G",aDriver[5],(If(aReturn[4]=1,aDriver[3],aDriver[4])))))
		ElseIf !lWin .and. __cInternet == Nil
			If nChar == 15
				@ 0,0 PSAY &(If(nTamanho=="P",aDriver[1],If(nTamanho=="G",aDriver[5],(If(aReturn[4]=1,aDriver[3],aDriver[4])))))
			Else
				@ 0,0 PSAY &(If(nTamanho=="P",aDriver[2],If(nTamanho=="G",aDriver[6],aDriver[4])))
			EndIf
		EndIf
	EndIF
EndIf

nCentro := (nLargura/2) - Len(cTitulo)

nLin := 0                            
@nLin,0 PSAY INICABEC //Token para identificar o inicio de uma cabec
nLin++
@nLin,0 PSAY Iif(!lWin,Chr(13),"")+REPLI("*",nLargura)
@ nLin,001 PSay Replicate("_",nLargura)	
NliN++
@ nLin,nCentro PSay cTitulo 
NliN++
@ nLin,000 PSay Replicate("_",nLargura)	
NliN++
@ nLin,000 PSay INIFIELD+cCabec1+FIMFIELD
NliN++
@ nLin,000 PSay INIFIELD+cCabec2+FIMFIELD
NliN++
@ nLin,000 PSay INIFIELD+cCabec3+FIMFIELD
NliN++
@ nLin,000 PSay Replicate("_",nLargura)
@ nLin,000 PSAY FIMCABEC //Token para identificar o final de uma cabec	
	
lFirst := .f.

Return .t.

