### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 4f9c9c32-599f-11eb-1c32-bf0e4576979b
using Plots

# ╔═╡ a957d1c4-599f-11eb-07ea-af0d67104f4b
import Pkg; Pkg.add("Plots")

# ╔═╡ 96165cee-5a78-11eb-33b6-abbbc7ce6cc9
"""Definición de objetos y funciones"""

# ╔═╡ 7ce2fa8c-599d-11eb-1d14-8d7ecf237c13
"""*
 Representa un objeto grilla 
"""
struct Grid{T<:Real}
	x_min::T
	x_max::T
	x_int::T
	y_min::T
	y_max::T
	y_int::T
end

# ╔═╡ 30886ac0-599e-11eb-0686-59f3bb2bb176
"""
	makeGrid(g::Grid)
Crear una matriz de rangos [rango_abcisas,rango_ordenadas]
"""
function makeGrid(g::Grid)

	rango_abcisas = g.x_min:g.x_int:g.x_max
	rango_ordenadas = g.y_min:g.y_int:g.y_max
	grid=[a+o*im for a in rango_abcisas, o in rango_ordenadas]
	
end

# ╔═╡ 5ed00486-59a5-11eb-04bd-05f099d8fd65
f1(z,c)=sin(z)+z^2+c

# ╔═╡ ad3eddea-59a5-11eb-025c-9bd1b7ef943d
f2(z,c)=z^z+z^6+c

# ╔═╡ bc8eee02-59a5-11eb-02bc-d30dff43c365
f3(z,c)=z^z+z^6+c

# ╔═╡ e2b57450-5a54-11eb-00aa-1d7b308c8f15
f4(z,c)=z^5+c

# ╔═╡ f0eb1426-5a54-11eb-30ee-1d3aa5a4e2ee
f5(z,c)=z^3+c

# ╔═╡ eff519e2-5a63-11eb-0142-cf7a63fe3512
fc(z,c)=z^2+c

# ╔═╡ 64175592-5a55-11eb-001e-3b14392687ff
""" *
	testJM(z::Complex)
Comprobar el criterio de convergencia para los conjuntos de Julia y Mandelbrot
"""
function testJM(z::Complex)
	if abs(z)<2
		return true
	else
		return false
	end
end

# ╔═╡ 6299fd4a-5a56-11eb-1577-e146fc4f99e6
"""
	testbiomorph(z::Complex,τ::Real)
Comprobar el criterio de convergencia para las formas biológicas
"""
function testbiomorph(z::Complex,τ::Real)
	if abs(real(z))<τ && abs(im(z))<τ
		return true
	else
		return false
	end
		
end

# ╔═╡ b90314ac-5a63-11eb-07d4-3789edbc2c66
"""
	iterate(test::Function,f::Function,z::Complex,iter::Integer)
Iterar z sobre una funcion f
"""
function iterate(test::Function,f::Function,z::Complex,c::Complex,iter::Integer,τ::Integer=100)
					
	for it in (1:iter)
		if (test==testJM && testJM(z)) || (test==testbiomorph && testbiomorph(z,τ))
			z=f(z,c)	
		else
			return false
		end
	end
	return true		
end

# ╔═╡ cbf8a58a-5a6e-11eb-3ef3-2d67842892bc
"""*
	colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
Retornar el número de iteraciones para un valor dado de z minetras un criterio de convergencia sea válido
"""
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer)
	it=1
	while it<=iter && iterate(test,f,z,c,it)
		it +=1
	end	
	return it-1
	
end

# ╔═╡ cbb171ae-5a77-11eb-02ef-75e7f6034a50
function colormap(f::Function,test::Function,z::Complex,c::Complex,iter::Integer,τ::Integer)
	it=1
	while it<=iter && iterate(test,f,z,c,it,τ)
		it +=1
	end	
	return it-1
end

# ╔═╡ cd1c934a-5a78-11eb-1c5e-afb0634726db
"""Solución a los incisos"""

# ╔═╡ dc14d4aa-5a78-11eb-0f5a-3156a6d06fdb
"""1) Graficar un conjunto de Julia, para un 𝑐 arbitrario (monocromático)."""

# ╔═╡ 8f923d04-5a78-11eb-0e0f-2b3dba98c2c4
"""
	setjulia()
Construir un array con los puntos del plano complejo que pertenecen al conjunto, dada la región de análisis del plano complejo
Entradas:
- f::Function
- test::Function
- grid::Array{T,2} where T
- c::Complex
- iter::Integer
"""
function setjulia(
		f::Function,
		test::Function,
		grid::Array{T,2} where T,
		c::Complex,
		iter::Integer)

	TL=length(grid)
	myArray = []
	for ind in 1:TL
		if colormap(f,test,grid[ind],c,iter)==iter
			append!(myArray, grid[ind])
		end
	end
	return myArray
	
end

# ╔═╡ 0f409dc6-5a8c-11eb-217c-e3d7b6608f45
begin
	x_min=-1.0
	x_max=1.0
	x_int=0.01
	y_min=-1.0
	y_max=1.0
	y_int=0.01
	myGrid_object=Grid(x_min,x_max,x_int,y_min,y_max,y_int)
	myGrid=makeGrid(myGrid_object)
end

# ╔═╡ de39faf6-5a8b-11eb-0049-1df9132b334b
juliaArray=setjulia(f1,testJM,myGrid,0.0+0im,10)

# ╔═╡ 938e14cc-5a97-11eb-0fe4-b527d4d7d44f
typeof(juliaArray[1])

# ╔═╡ 5abd04f4-5a96-11eb-0204-0125025e6936
begin
	size = 50
	Plots.default(size = (2200,2200),titlefontsize = size, tickfontsize = size, legendfontsize = size, guidefontsize = size, legendtitlefontsize = size)
end

# ╔═╡ 5cbd6f22-5a96-11eb-340a-75743cd2a98c
begin
	scatter([juliaArray[i] for i in 1:length(juliaArray)], seriescolor=:white,
		    markerstrokecolor=:blue,
		    aspectratio=1,
		    title="Gráfica del conjunto de Julia",
			legend=false,
			markersize=40)
end

# ╔═╡ 94878d5e-5a79-11eb-1b1e-59fa181a3696
"""2) Graficar el conjunto de Mandelbrot (monocromático)."""

# ╔═╡ 53fd47c4-5a79-11eb-0964-2398856c3c47
"""
	setmandelbrot()
Construir un array con los puntos del plano complejo que pertenecen al conjunto, dada la región de análisis del plano complejo
Entradas:
- f::Function
- test::Function
- grid::Array{T,2} where T
- iter::Integer
"""
function setmandelbrot(
		f::Function,
		test::Function,
		grid::Array{T,2} where T,
		iter::Integer)
	z=0.0+0im
	c=0.0+0.0im
	TL=length(grid)
	myArray = []
	for ind in 1:TL
		if colormap(f,test,z,c,iter)==iter
			append!(myArray, grid[ind])
		end
	end
	return myArray
	
end

# ╔═╡ 4bf7c286-5a8b-11eb-29fc-0d59ad9f7901
colormap(f1,testJM,0.0+0.1im,0.0+0im,10)

# ╔═╡ 5726cb82-5a79-11eb-2920-b1f74a9eda25
mandArray=setmandelbrot(f1,testJM,myGrid,10)


# ╔═╡ 4247773c-599f-11eb-1ee5-cf9384df918a
begin
	x = x_min:x_int:x_max
	y = y_min:y_int:y_max
	colores = [colormap(f1,testJM,i₁+i₂*im,0.0+0im,10) for i₁ in x, i₂ in y]
	heatmap(x, y, colores, color=cgrad([:black,:blue,:white]), 
		    title="Mapa de Calor Conjunto de Mandelbrot", xlabel="Re(z)", ylabel="Im(z)")
end

# ╔═╡ Cell order:
# ╠═a957d1c4-599f-11eb-07ea-af0d67104f4b
# ╠═4f9c9c32-599f-11eb-1c32-bf0e4576979b
# ╠═96165cee-5a78-11eb-33b6-abbbc7ce6cc9
# ╠═7ce2fa8c-599d-11eb-1d14-8d7ecf237c13
# ╠═30886ac0-599e-11eb-0686-59f3bb2bb176
# ╠═5ed00486-59a5-11eb-04bd-05f099d8fd65
# ╠═ad3eddea-59a5-11eb-025c-9bd1b7ef943d
# ╠═bc8eee02-59a5-11eb-02bc-d30dff43c365
# ╠═e2b57450-5a54-11eb-00aa-1d7b308c8f15
# ╠═f0eb1426-5a54-11eb-30ee-1d3aa5a4e2ee
# ╠═eff519e2-5a63-11eb-0142-cf7a63fe3512
# ╠═64175592-5a55-11eb-001e-3b14392687ff
# ╠═6299fd4a-5a56-11eb-1577-e146fc4f99e6
# ╠═b90314ac-5a63-11eb-07d4-3789edbc2c66
# ╠═cbf8a58a-5a6e-11eb-3ef3-2d67842892bc
# ╠═cbb171ae-5a77-11eb-02ef-75e7f6034a50
# ╠═cd1c934a-5a78-11eb-1c5e-afb0634726db
# ╠═dc14d4aa-5a78-11eb-0f5a-3156a6d06fdb
# ╠═8f923d04-5a78-11eb-0e0f-2b3dba98c2c4
# ╠═0f409dc6-5a8c-11eb-217c-e3d7b6608f45
# ╠═de39faf6-5a8b-11eb-0049-1df9132b334b
# ╠═938e14cc-5a97-11eb-0fe4-b527d4d7d44f
# ╠═5abd04f4-5a96-11eb-0204-0125025e6936
# ╠═5cbd6f22-5a96-11eb-340a-75743cd2a98c
# ╠═94878d5e-5a79-11eb-1b1e-59fa181a3696
# ╠═53fd47c4-5a79-11eb-0964-2398856c3c47
# ╠═4bf7c286-5a8b-11eb-29fc-0d59ad9f7901
# ╠═5726cb82-5a79-11eb-2920-b1f74a9eda25
# ╠═4247773c-599f-11eb-1ee5-cf9384df918a
