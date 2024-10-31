extends Node2D

# Variáveis para os objetos do olho aberto, olho fechado e disco voador
var olho
var olho_fechado
var disco_voador

# Parâmetros de translação
var raio = 200  # Raio da órbita do disco voador
var velocidade_linear = 250  # Velocidade linear 

# Posição do olho
var olho_posicao

func _ready():
	# Inicializa os objetos
	olho = $Olho
	olho_fechado = $Olhofechado
	disco_voador = $Disco
	
	# Define a posição inicial do olho
	olho_posicao = olho.get_global_position()
	
	# Define a visibilidade inicial
	olho.visible = true
	olho_fechado.visible = false

func _process(delta):
	# Calcula a velocidade angular
	var velocidade_angular = velocidade_linear / raio
	
	# Calcula o ângulo atual em graus
	var angulo_atual = velocidade_angular * delta * (180 / PI)

	# Usa a função rotate_point para calcular a nova posição do disco em torno do olho
	var nova_posicao = rotate_point(disco_voador.position.x, disco_voador.position.y, olho_posicao.x, olho_posicao.y, angulo_atual)
	disco_voador.set_global_position(Vector2(nova_posicao[0], nova_posicao[1]))

	# Checa se o disco voador está no campo de visão do olho
	atualizar_estado_olho()

# Função para rotacionar um ponto em torno de um centro dado um ângulo em graus
func rotate_point(x, y, centerx, centery, degrees):
	var rad = deg_to_rad(degrees)  # Converte graus para radianos
	var newx = (x - centerx) * cos(rad) - (y - centery) * sin(rad) + centerx
	var newy = (x - centerx) * sin(rad) + (y - centery) * cos(rad) + centery
	return [newx, newy]

func atualizar_estado_olho():
	# Vetor do olho para o disco voador
	var v = (disco_voador.get_global_position() - olho_posicao).normalized()
	
	# Vetor de referência do campo de visão do olho
	var w = Vector2(3, -1) 
	
	# Calcula o produto vetorial entre os vetores v e w
	var alpha = v.x * w.x + v.y * w.y
	
	# Verifica se o disco está à direita do olho e no campo de visão
	if alpha > 0.717:
		olho.visible = true
		olho_fechado.visible = false
	else:
		olho.visible = false
		olho_fechado.visible = true
