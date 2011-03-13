module T
  unless defined? A
    class A
    end
  end

  unless defined? B
    class B < A
    end
  end

  M = ('abc'..'abz').to_a unless defined? M
  N = (1..19).to_a unless defined? N

  unless defined? H
    H = {}; M.each { |elt| H[elt.to_sym] = "#{elt}_value" }
  end
end

include T
