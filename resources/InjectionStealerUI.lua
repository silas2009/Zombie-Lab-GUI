local a=Instance.new"Frame"
a.Name="InjectionStealer"
a.ZIndex=2
a.AnchorPoint=Vector2.new(0.5,0.5)
a.Visible=false
a.Size=UDim2.new(0,400,0,250)
a.BackgroundTransparency=1
a.Position=UDim2.new(0.5,0,0.5,0)
a.BackgroundColor3=Color3.fromRGB(255,255,255)
local b=Instance.new"Frame"
b.Name="Topbar"
b.Size=UDim2.new(1,0,0,28)
b.BorderColor3=Color3.fromRGB(32,32,32)
b.BackgroundColor3=Color3.fromRGB(64,64,64)
b.Parent=a
local c=Instance.new"TextLabel"
c.Size=UDim2.new(1,0,1,0)
c.BackgroundTransparency=1
c.BackgroundColor3=Color3.fromRGB(255,255,255)
c.FontSize=6
c.TextStrokeTransparency=0.9
c.TextSize=15
c.TextColor3=Color3.fromRGB(255,255,255)
c.Text="Injection Stealer - Username"
c.FontFace=Font.new("rbxasset://fonts/families/Inconsolata.json",Enum.FontWeight.Bold)
c.TextXAlignment=0
c.TextStrokeColor3=Color3.fromRGB(255,255,255)
c.Parent=b
local d=Instance.new"UIPadding"
d.PaddingLeft=UDim.new(0,6)
d.Parent=c
local e=Instance.new"Frame"
e.Name="Container"
e.Size=UDim2.new(1,-10,1,-5)
e.BackgroundTransparency=1
e.Position=UDim2.new(0,5,0,5)
e.BackgroundColor3=Color3.fromRGB(255,255,255)
e.Parent=b
local f=Instance.new"TextButton"
f.Name="Exit"
f.Size=UDim2.new(0,20,0,20)
f.Position=UDim2.new(1,-20,0,0)
f.BackgroundColor3=Color3.fromRGB(255,0,89)
f.FontSize=6
f.TextSize=16
f.TextColor3=Color3.fromRGB(255,255,255)
f.Text="X"
f.Font=17
f.Parent=e
local g=Instance.new"UICorner"
g.CornerRadius=UDim.new(0,4)
g.Parent=f
local h=Instance.new"Frame"
h.Name="Container"
h.Size=UDim2.new(1,0,1,-28)
h.Position=UDim2.new(0,0,0,28)
h.BackgroundColor3=Color3.fromRGB(0,0,0)
h.Parent=a
local i=Instance.new"Frame"
i.Name="Buttons"
i.Size=UDim2.new(1,0,1,0)
i.BorderColor3=Color3.fromRGB(32,32,32)
i.BackgroundColor3=Color3.fromRGB(56,56,56)
i.Parent=h
local j=Instance.new"ScrollingFrame"
j.Size=UDim2.new(1,0,1,0)
j.BorderColor3=Color3.fromRGB(32,32,32)
j.Active=true
j.BackgroundColor3=Color3.fromRGB(48,48,48)
j.AutomaticCanvasSize=2
j.CanvasSize=UDim2.new(0,0,0,0)
j.ScrollBarImageColor3=Color3.fromRGB(0,0,0)
j.ScrollBarThickness=8
j.Parent=i
local k=Instance.new"UIPadding"
k.Parent=j
local l=Instance.new"UIGridLayout"
l.SortOrder=2
l.CellSize=UDim2.new(0,60,0,60)
l.Parent=j
local m=Instance.new"UIPadding"
m.PaddingTop=UDim.new(0,5)
m.PaddingBottom=UDim.new(0,5)
m.PaddingLeft=UDim.new(0,5)
m.PaddingRight=UDim.new(0,5)
m.Parent=i
return a
