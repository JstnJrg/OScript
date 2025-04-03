package OScriptVM


// Nota(jstn): -1 corresponde a tabela de globais
change_context :: proc "contextless" (p,c: ^CallFrame) { if c.context_ID != p.context_ID do c.globals = c.context_ID != -1 ? get_import_context_importID(c.context_ID): &current_vm.globals }