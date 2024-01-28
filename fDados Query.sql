    SELECT DISTINCT
        t1.Pedido,
        t1.filial,
        t1.LANCAMENTO_NOTA_SAIDA as data,
        t1.SlpCode SlpCode_NF,
        t1.SlpName Representante_NF,
        t1.CardCode as clientecod,
        t1.nfe,
        t1.ItemCode,
        t1.Linenum,
        t1.OperacaoFiscal,
        t1.Total_Linha_Depois_Desconto as valor,
        T2.DESPESAS_ADICIONAIS / (SELECT COUNT(*)
        FROM SBODISCOVER..[VW_EN_VENDAS_POWER_BI] T11
        WHERE T11.NFE = T1.NFE
                                ) AS Despesas_Adicionais,
        t1.quantidade,
        null as 'Motivo',
        t1.Cod_Imposto,
        t1.Aliquota_Imposto
 
    FROM SBODISCOVER..[VW_EN_VENDAS_POWER_BI] T1
        LEFT JOIN SBODISCOVER..[VW_EN_DESPESAS_ADICIONAIS] T2 ON T2.NFE = T1.NFE AND T2.FILIAL = T1.FILIAL
 
    WHERE YEAR(t1.LANÇAMENTO_NOTA_SAIDA) >= YEAR(GETDATE())-5
 
        AND t1.OperacaoFiscal = 'VENDA'
        AND t1.DOCENTRY_NOTA_SAIDA <> 'Nota cancelada'
    --AND t1.NFE = '274230'
 
 
UNION ALL
 
 
    SELECT DISTINCT
        t1.Pedido,
        t1.filial,
        t1.LANCAMENTO_DEVOLUÇÃO as data,
        t1.SlpCode SlpCode_NF,
        t1.SlpName Representante_NF,
        t1.CardCode as clientecod,
        t1.nfe,
        t1.itemcode,
        t1.Linenum,
        t1.operacaofiscal,
        t1.Total_Linha_Depois_Desconto as Valor,
        t2.Despesas_Adicionais /    (select count(*)
        from SBODISCOVER..VW_EN_DEVOLUCOES_POWER_BI t11
        where  t11.NFE = t1.NFE and t1.CardCode = t11.CardCode) as Despesas_Adicionais,
        t1.quantidade,
        t1.Motivo_Devolucao as 'Motivo',
        t1.Cod_Imposto,
        t1.Aliquota_Imposto
 
    FROM SBODISCOVER..VW_EN_DEVOLUCOES_POWER_BI t1
        LEFT JOIN SBODISCOVER..[VW_EN_DESPESAS_ADICIONAIS] T2 ON T2.NFE = T1.NFE AND T2.FILIAL = T1.FILIAL and t1.CardCode = t2.CardCode and t2.OperacaoFiscal = 'DEVOLUCAO'
 
    WHERE t1.FATURAMENTO_ANO >= YEAR(GETDATE())-5
        AND t1.OperacaoFiscal = 'devolucao'
        AND t1.DOCENTRY_DEVOLUÇÃO <> 'DEVOLUÇÃO CANCELADA'
    --AND t1.NFE = '274230'
