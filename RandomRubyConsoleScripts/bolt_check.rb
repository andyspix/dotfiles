
def act_hash
  return @act_hash if @act_hash.present?

  cids = CalampMessage.distinct(:mobile_id).pluck(:mobile_id)
  @act_hash = cids.map { |c| [c, CalampDevice.find_by(calamp_id: c)&.device&.account&.account_name] }.to_h
end

def msg_data(date)
  res = Hash.new(0)
  mids = CalampMessage.where(created_at: date.beginning_of_day..date.end_of_day).group(:mobile_id).count
  mids.each { |k,v| res[act_hash[k]] += v }
  res
end

(Date.parse('Wed, 06 Apr 2022')..Date.today).map { |d| msg_data(d) }


[
    [ 0] {
                       "John Deere" => 2138,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 130500,
            "(PWS Retired Devices)" => 36
    },
    [ 1] {
                       "John Deere" => 1566,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 443121,
            "(PWS Retired Devices)" => 48
    },
    [ 2] {
                       "John Deere" => 1398,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 813483,
            "(PWS Retired Devices)" => 48
    },
    [ 3] {
                       "John Deere" => 366,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 710007,
            "(PWS Retired Devices)" => 50
    },
    [ 4] {
                       "John Deere" => 396,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 668564,
            "(PWS Retired Devices)" => 48
    },
    [ 5] {
                       "John Deere" => 1148,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 497999,
            "(PWS Retired Devices)" => 52
    },
    [ 6] {
                       "John Deere" => 1648,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 404162,
            "(PWS Retired Devices)" => 48
    },
    [ 7] {
                       "John Deere" => 1278,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 404626,
            "(PWS Retired Devices)" => 48
    },
    [ 8] {
                       "John Deere" => 1102,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 555133,
            "(PWS Retired Devices)" => 48
    },
    [ 9] {
                       "John Deere" => 780,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 621544,
            "(PWS Retired Devices)" => 48
    },
    [10] {
                       "John Deere" => 542,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 755680,
            "(PWS Retired Devices)" => 48
    },
    [11] {
                       "John Deere" => 540,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 735114,
            "(PWS Retired Devices)" => 48
    },
    [12] {
                       "John Deere" => 1434,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 445658,
            "(PWS Retired Devices)" => 48
    },
    [13] {
                       "John Deere" => 1102,
              "Minnesota Equipment" => 22,
        "Bolt Mobility Corporation" => 454507,
            "(PWS Retired Devices)" => 48
    },
    [14] {
                       "John Deere" => 1342,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 590184,
            "(PWS Retired Devices)" => 50
    },
    [15] {
                       "John Deere" => 1502,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 498729,
            "(PWS Retired Devices)" => 48
    },
    [16] {
                       "John Deere" => 674,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 481441,
            "(PWS Retired Devices)" => 48
    },
    [17] {
                       "John Deere" => 380,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 579790,
            "(PWS Retired Devices)" => 48
    },
    [18] {
                       "John Deere" => 474,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 606750,
            "(PWS Retired Devices)" => 48
    },
    [19] {
                       "John Deere" => 1580,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 563988,
            "(PWS Retired Devices)" => 48
    },
    [20] {
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 503206,
            "(PWS Retired Devices)" => 48
    },
    [21] {
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 623181,
            "(PWS Retired Devices)" => 48
    },
    [22] {
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 781201,
            "(PWS Retired Devices)" => 48
    },
    [23] {
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 437011,
            "(PWS Retired Devices)" => 48
    },
    [24] {
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 366902,
            "(PWS Retired Devices)" => 76
    },
    [25] {
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 677830,
            "(PWS Retired Devices)" => 48
    },
    [26] {
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 391465,
            "(PWS Retired Devices)" => 48
    },
    [27] {
               "Pepsi Demo Account" => 10,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 357170,
            "(PWS Retired Devices)" => 48
    },
    [28] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 369636,
            "(PWS Retired Devices)" => 52
    },
    [29] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 359365,
            "(PWS Retired Devices)" => 48
    },
    [30] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 363700,
            "(PWS Retired Devices)" => 48
    },
    [31] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 317081,
            "(PWS Retired Devices)" => 48
    },
    [32] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 449064,
            "(PWS Retired Devices)" => 48
    },
    [33] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 305884,
            "(PWS Retired Devices)" => 52
    },
    [34] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 300596,
            "(PWS Retired Devices)" => 48
    },
    [35] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 323236,
            "(PWS Retired Devices)" => 48
    },
    [36] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 443251,
            "(PWS Retired Devices)" => 50
    },
    [37] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 366313,
            "(PWS Retired Devices)" => 48
    },
    [38] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 384595,
            "(PWS Retired Devices)" => 48
    },
    [39] {
               "Pepsi Demo Account" => 8,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 194541,
            "(PWS Retired Devices)" => 48
    },
    [40] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 273510,
            "(PWS Retired Devices)" => 48
    },
    [41] {
               "Pepsi Demo Account" => 22,
              "Minnesota Equipment" => 20,
        "Bolt Mobility Corporation" => 151879,
            "(PWS Retired Devices)" => 48
    },
    [42] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 89759,
            "(PWS Retired Devices)" => 50
    },
    [43] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 95073,
            "(PWS Retired Devices)" => 48
    },
    [44] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 101763,
            "(PWS Retired Devices)" => 48
    },
    [45] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 75297,
            "(PWS Retired Devices)" => 50
    },
    [46] {
               "Pepsi Demo Account" => 10,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 168714,
            "(PWS Retired Devices)" => 50
    },
    [47] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 272151,
            "(PWS Retired Devices)" => 48
    },
    [48] {
               "Pepsi Demo Account" => 20,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 239697,
            "(PWS Retired Devices)" => 48
    },
    [49] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 234877,
            "(PWS Retired Devices)" => 64
    },
    [50] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 227056,
            "(PWS Retired Devices)" => 50
    },
    [51] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 146381,
            "(PWS Retired Devices)" => 58
    },
    [52] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 90686,
            "(PWS Retired Devices)" => 48
    },
    [53] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 66815,
            "(PWS Retired Devices)" => 50
    },
    [54] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 46384,
            "(PWS Retired Devices)" => 48
    },
    [55] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 38925,
            "(PWS Retired Devices)" => 50
    },
    [56] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 20,
        "Bolt Mobility Corporation" => 28771,
            "(PWS Retired Devices)" => 48
    },
    [57] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 49141,
            "(PWS Retired Devices)" => 50
    },
    [58] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 56711,
            "(PWS Retired Devices)" => 48
    },
    [59] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 93343,
            "(PWS Retired Devices)" => 48
    },
    [60] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 327542,
            "(PWS Retired Devices)" => 52
    },
    [61] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 277771,
            "(PWS Retired Devices)" => 48
    },
    [62] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 267974,
            "(PWS Retired Devices)" => 50
    },
    [63] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 258870,
            "(PWS Retired Devices)" => 50
    },
    [64] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 109873,
            "(PWS Retired Devices)" => 48
    },
    [65] {
               "Pepsi Demo Account" => 10,
              "Minnesota Equipment" => 12,
                        "Razor USA" => 2,
        "Bolt Mobility Corporation" => 78366,
            "(PWS Retired Devices)" => 58
    },
    [66] {
               "Pepsi Demo Account" => 10,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 139416,
            "(PWS Retired Devices)" => 52
    },
    [67] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 297506,
            "(PWS Retired Devices)" => 46
    },
    [68] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 232072,
            "(PWS Retired Devices)" => 48
    },
    [69] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 26,
        "Bolt Mobility Corporation" => 232513,
            "(PWS Retired Devices)" => 48
    },
    [70] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 57107,
            "(PWS Retired Devices)" => 48
    },
    [71] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 27295,
            "(PWS Retired Devices)" => 48
    },
    [72] {
               "Pepsi Demo Account" => 16,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 25753,
            "(PWS Retired Devices)" => 50
    },
    [73] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 35964,
            "(PWS Retired Devices)" => 52
    },
    [74] {
               "Pepsi Demo Account" => 18,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 175558,
            "(PWS Retired Devices)" => 48
            :q
    },
    [75] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 226107,
            "(PWS Retired Devices)" => 48
    },
    [76] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 217628,
            "(PWS Retired Devices)" => 48
    },
    [77] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 75407,
            "(PWS Retired Devices)" => 62
    },
    [78] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 36366,
            "(PWS Retired Devices)" => 50
    },
    [79] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 15235,
            "(PWS Retired Devices)" => 48
    },
    [80] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 18,
        "Bolt Mobility Corporation" => 15420,
            "(PWS Retired Devices)" => 48
    },
    [81] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 15438,
            "(PWS Retired Devices)" => 48
    },
    [82] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 14675,
            "(PWS Retired Devices)" => 48
    },
    [83] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 10,
        "Bolt Mobility Corporation" => 16447,
            "(PWS Retired Devices)" => 48
    },
    [84] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 15212,
            "(PWS Retired Devices)" => 48
    },
    [85] {
               "Pepsi Demo Account" => 10,
              "Minnesota Equipment" => 16,
        "Bolt Mobility Corporation" => 15032,
            "(PWS Retired Devices)" => 48
    },
    [86] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 15254,
            "(PWS Retired Devices)" => 50
    },
    [87] {
                                nil => 1,
               "Pepsi Demo Account" => 24,
              "Minnesota Equipment" => 14,
        "Bolt Mobility Corporation" => 15237,
            "(PWS Retired Devices)" => 48
    },
    [88] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 15357,
            "(PWS Retired Devices)" => 50
    },
    [89] {
               "Pepsi Demo Account" => 14,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 15338,
            "(PWS Retired Devices)" => 48
    },
    [90] {
               "Pepsi Demo Account" => 28,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 14139,
            "(PWS Retired Devices)" => 48
    },
    [91] {
               "Pepsi Demo Account" => 12,
              "Minnesota Equipment" => 12,
        "Bolt Mobility Corporation" => 10447,
            "(PWS Retired Devices)" => 40
    }
]
