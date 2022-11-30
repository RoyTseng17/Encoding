module EncodingMod
    using APSObjects
export 
    get_sol1,
    create_original_sol,
    create_CR_sol,
    create_EDD_sol,
    create_SPT_sol,
    create_customized_sol,
    create_partial_sol
include("./Encoding.jl")

end # module
#using EncodingMod