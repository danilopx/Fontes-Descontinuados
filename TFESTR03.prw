#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//---------------------------------------------------------------------------------------------------------------------------
// Programa: TFESTR03 																					Autor: C. Torres        Data: 13/09/2011 
// Descricao: Mapa de movimentação diaria por produto ocorrida Em/De Terceiros
//---------------------------------------------------------------------------------------------------------------------------
User Function TFESTR03()
                       
Private cAliasTrb	:= "TMPES03" // GetNextAlias()
Private cPerg     := 'TFESTR03'
Private cString	:= 'Query'                                     
Private oReport

// AjustaSx1( cPerg ) // Chama funcao de pergunta
If SM0->M0_CODIGO $ '01x02'
	If pergunte(cPerg,.T.)
 			
		Processa( {|lEnd| U_TERTExcel1(@lEnd) } ,  'Movimentação Em/De Terceiros' , 'Aguarde, preparando planilha...' , .T. )
		
	EndIf
Else
	Aviso("Modulo não disponivel", "Modulo não disponivel para a empresa selecionada.", {"Ok"}, 3)
EndIF     
Return
  

//--------------------------------------------------------------------------------------------------------------
// Função: TExcel1 - Exportação para Excel
//--------------------------------------------------------------------------------------------------------------
User Function TERTExcel1(lEnd)
 
Local __aHeader := {}
Local __aCols   := {}
Local _nQT_SALDOINI
Local _cVariavel
Local	__lInterrompido := .F.
Local _nVlCusto := 0

If TCSPExist("SP_REL_MOVIMENTO_DIARIO_PODER3")
	If SM0->M0_CODIGO='01'
		_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO_PODER3 '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO_PODER3
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
	EndIf
	If SM0->M0_CODIGO='02'
		_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO_PODER3_MERCABEL '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO_PODER3
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
	EndIf
		
	If Select( (cAliasTrb) ) > 0
		dbSelectArea( (cAliasTrb) )
		DbCloseArea()
	EndIf

	TCQUERY _cQuery NEW ALIAS "TMPES03"

EndIf
dbSelectArea( (cAliasTrb) )

ProcRegua( (cAliasTrb)->(reccount()) )


If !ApOleClient("MSExcel")
 	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf

aTam := TamSX3('B6_PRODUTO'	); Aadd(__aHeader, {'Produto'			, 'ID_PRODUTO'	, PesqPict('SB6', 'B6_PRODUTO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B1_DESC'		); Aadd(__aHeader, {'Descricao'		, 'NM_PRODUTO'	, PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B1_TIPO'		); Aadd(__aHeader, {'Tipo'				, 'B1_TIPO'		, PesqPict('SB1', 'B1_TIPO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B6_TIPO'		); Aadd(__aHeader, {'Movto. Poder'	, 'B6_TIPO'		, PesqPict('SB6', 'B6_TIPO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B6_LOCAL'		); Aadd(__aHeader, {'Armazen'			, 'ID_LOCAL'	, PesqPict('SB6', 'B6_LOCAL'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B6_QUANT'		); Aadd(__aHeader, {'Saldo Inicial'	, 'SLD_INICIAL', PesqPict('SB6', 'B6_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
                
ZAJ->(DbSetOrder(1))
ZAJ->(DbGoTop())
While !ZAJ->(Eof())
	aTam := TamSX3('B6_QUANT'		); Aadd(__aHeader, { Alltrim(ZAJ->ZAJ_DESCR)	, '_nQT'+Alltrim(ZAJ->ZAJ_TIPO)+StrZero(Val(ZAJ->ZAJ_COD),3), PesqPict('SB6', 'B6_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
	ZAJ->(DbSkip())
End

aTam := TamSX3('B6_QUANT'		); Aadd(__aHeader, {'Saldo Final'	, '_nQTFinal', PesqPict('SB6', 'B6_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('B2_VATU1'		); Aadd(__aHeader, {'Custo'			, '_nVlCusto', PesqPict('SB2', 'B2_VATU1'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('B1_DESC'		); Aadd(__aHeader, {'Empresa'			, '_cEmpresa', PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 

_cEmpresa := Alltrim(SM0->M0_NOME) + "-" + SM0->M0_FILIAL

While !(cAliasTrb)->(Eof()) .AND. !__lInterrompido

	_nQT_SALDOINI	:= (cAliasTrb)->SLD_INICIAL
	_cIdProduto		:= (cAliasTrb)->ID_PRODUTO 
	_cIdLocal 		:= (cAliasTrb)->ID_LOCAL
	_cNmProduto		:= (cAliasTrb)->NM_PRODUTO
	_cTpProduto		:= (cAliasTrb)->B1_TIPO
	_cSB6tipo		:= (cAliasTrb)->B6_TIPO
	_nVlCusto		:= (cAliasTrb)->VL_CUSTO

	ZAJ->(DbGoTop())
	While !ZAJ->(Eof())
		If ZAJ->ZAJ_TIPO $ 'ExS'
			_cVariavel := '_nQT' + Alltrim(ZAJ->ZAJ_TIPO) + StrZero(Val(ZAJ->ZAJ_COD),3)
			&_cVariavel := 0
		EndIf
		ZAJ->(DbSkip())
	End
	
	_nTT_Geral	:= _nQT_SALDOINI
	_nQTFinal	:= _nQT_SALDOINI

	While !(cAliasTrb)->(Eof()) .and. (cAliasTrb)->(ID_PRODUTO + ID_LOCAL + B6_TIPO) = _cIdProduto + _cIdLocal + _cSB6tipo
		IncProc()	
   	If lEnd
      	MsgInfo(cCancela,"Fim")
      	__lInterrompido := .T.
	      Exit
   	Endif
   	
      If !Empty( (cAliasTrb)->ZAJ_COD ) .and. (cAliasTrb)->ZAJ_TIPO != "X"

			_cVariavel 	:= "_nQT" + Alltrim((cAliasTrb)->ZAJ_TIPO) + (cAliasTrb)->ZAJ_COD
			&_cVariavel += (cAliasTrb)->TT_QUANT
			_nTT_Geral 	+= (cAliasTrb)->TT_QUANT
			_nQTFinal	+= (cAliasTrb)->TT_QUANT
		
		EndIf
		(cAliasTrb)->(dbSkip())
	End
	
	_nVlCusto := _nQTFinal * _nVlCusto

	If _nTT_Geral != 0

		If SM0->M0_CODIGO $ '01x02'
		
			AAdd(  __aCols , { ;
								_cIdProduto					,;
								_cNmProduto					,;
								_cTpProduto					,;
								_cSB6tipo					,;
								_cIdLocal					,;
								_nQT_SALDOINI				,;
								_nQTS001						,;
								_nQTS002						,;
								_nQTS003						,;
								_nQTS004						,;
								_nQTS005						,;
								_nQTE006						,;
								_nQTE007						,;
								_nQTE008						,;
								_nQTE009						,;
								_nQTE010						,;
								_nQTS011						,;
								_nQTFinal					,;
								_nVlCusto					,;
								_cEmpresa					,;
								 .F.})

		EndIf								 
	EndIf
	
End
 
If len( __aCols ) > 0 .AND. .NOT. lEnd
	DlgToExcel({ {"GETDADOS", "Movimentação Poder DE/EM Terceiros "+Dtoc(mv_par01) + " a "+Dtoc(mv_par02), __aHeader, __aCols} })
ElseIf .NOT. lEnd
	MsgAlert("Não há dados a exportar para o Excel!","")
EndIf

Return
