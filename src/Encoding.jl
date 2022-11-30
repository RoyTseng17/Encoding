
#作業順序(長度 = Nvar的解) [0.24, 0.65, 0.78]
function get_random_key(Nops)
    part_sol = rand(Nops)
    return part_sol
end

#可用機群指派
function get_rs_assignment(UB_list) #3, 5, 3 => 1~3, 1~5, 1~3
    part_sol = []
    for UB in UB_list
        rv = rand(1:UB)
        push!(part_sol, rv)
    end
    return part_sol
end

function get_part3(data)
    sol = []
    length = data.data_dict["length"]
    for i = 1:length
        push!(sol, rand())
    end
    return sol
end
#產生初始解 方法1
function get_sol1(encoding_dict)
    sol = []
    sorted_encoding_policies = sort(collect(encoding_dict), by = x -> x[2][1])
    for (encoding_func, values) in sorted_encoding_policies
        if encoding_func isa Function
            args = values[2]
            sol = vcat(sol, encoding_func(args...))
        end
    end
    return sol
end
function CR_mcg_encoding_policy()
    part2 = []
    for UB in UB_list
        push!(part2, 1)
    end
    return part2
    #產生CR解  (20分鐘)
    #跑多代 多組解 檢視CR解 與最終優化解的比率(30分鐘)
    #問看需要幾次獨立試驗
end
function create_original_sol(data)
    println("ASCH初始解")
    all_op_list = data["all_op_list"]
    N = size(data["all_op_list"], 1)
    seq_all_op_list = [x.info["idx"] for x in all_op_list]
    sum_seq = sum(seq_all_op_list)
    data["sum_seq"] = sum_seq

    part1 = seq_all_op_list .* (1 / sum_seq)

    match_dict = data["match_dict"]
    part2 = [match_dict[op.info["OPR_RESOURCE_CODE"]] for op in data["all_op_list"]]
    return vcat(part1, part2)
end
function set_CR!(op)
    load = 0
    if op isa CompositeOperation
        for sub_op in op.sub_op_list
            load += sub_op.info["duration"]
        end
        op.info["CR"] = op.info["DD"]/load
    else
        op.info["CR"] = op.info["DD"]/op.info["duration"]
    end
end
function create_CR_sol(data)
    println("CR初始解")
    all_op_list = data["all_op_list"]
    N = size(data["all_op_list"], 1)

    for op in all_op_list
        set_CR!(op)
    end
    
    seq_all_op_list = [x.info["CR"] for x in all_op_list]
    sum_seq = sum(seq_all_op_list)
    data["sum_seq"] = sum_seq
    part1 = seq_all_op_list .* (1 / sum_seq)
    match_dict = data["match_dict"]
    part2 = [match_dict[op.info["OPR_RESOURCE_CODE"]] for op in data["all_op_list"]]
    return vcat(part1, part2)
end

function create_EDD_sol(data)
    println("EDD初始解")
    all_op_list = data["all_op_list"]
    N = size(data["all_op_list"], 1)

    seq_all_op_list = [x.info["DD"] for x in all_op_list]
    sum_seq = sum(seq_all_op_list)
    data["sum_seq"] = sum_seq

    part1 = seq_all_op_list .* (1 / sum_seq)

    match_dict = data["match_dict"]
    part2 = [match_dict[op.info["OPR_RESOURCE_CODE"]] for op in data["all_op_list"]]
    return vcat(part1, part2)
end
function create_SPT_sol(data)
    println("SPT初始解")
    all_op_list = data["all_op_list"]
    N = size(data["all_op_list"], 1)

    seq_all_op_list = [x.info["duration"] for x in all_op_list]
    sum_seq = sum(seq_all_op_list)
    data["sum_seq"] = sum_seq

    part1 = seq_all_op_list .* (1 / sum_seq)

    match_dict = data["match_dict"]
    part2 = [match_dict[op.info["OPR_RESOURCE_CODE"]] for op in data["all_op_list"]]
    return vcat(part1, part2)
end
function create_customized_sol(data)
    println("EDD初始解")
    all_op_list = data["all_op_list"]
    N = size(data["all_op_list"], 1)
  
    seq_all_op_list = [x.info["DD"] for x in all_op_list]
    sum_seq = sum(seq_all_op_list)
    data["sum_seq"] = sum_seq

    part1 = seq_all_op_list .* (1 / sum_seq)
    for (idx, op) in enumerate(all_op_list)
        set_CR!(op)
        if op.info["CR"]<1
            part1[idx] = 0.9999999999999
        end
    end
    match_dict = data["match_dict"]
    part2 = [match_dict[op.info["OPR_RESOURCE_CODE"]] for op in data["all_op_list"]]
    return vcat(part1, part2)
end

function create_partial_sol(data)
    data["temp_sol"]
    partial_sol_idx_list = data["partial_sol_idx_list"]
    seq = rand(length(partial_sol_idx_list))
    ma = rand(1:length(partial_sol_idx_list), 4)
    partial_sol = vcat(seq, ma)
    return partial_sol
end