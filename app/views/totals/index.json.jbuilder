json.income @income
json.gross_expenditures @gross_expenditures
json.taxes(@net_expenditures - @gross_expenditures)
json.net_expenditures @net_expenditures
json.total(@income - @net_expenditures)
