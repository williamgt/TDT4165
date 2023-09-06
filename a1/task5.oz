local Circle Pi=(355.0/113.0) in
  proc {Circle R} A=Pi*R*R D=2.0*R C=Pi*D in
    {System.showInfo A}
    {System.showInfo D}
    {System.showInfo C}
  end

  {Circle 10.0}
end