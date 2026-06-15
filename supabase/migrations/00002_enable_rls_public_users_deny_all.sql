-- Micro-paquete 2B-I: public.users queda cerrado a clientes por defecto.
-- Sin políticas, RLS deniega todas las filas a anon y authenticated.
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
