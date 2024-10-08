'use client';

import AlertMessage from '@/components/elements/AlertMessage';
import FormInput from '@/components/elements/FormInput';
import { Form } from '@/components/ui/form';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { loginSchema, LoginSchema } from '@/schema/auth-schema';
import { Button } from '@/components/ui/button';
import { authService } from '@/service/auth-service';
import { useRouter } from 'next/navigation';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useAlertMessage } from '@/hooks/use-alert-message';

interface SignInFormProps {
  type: 'user' | 'company';
}

export default function SignInForm(props: SignInFormProps) {
  const { alertMessage, setAlertMessage } = useAlertMessage();
  const router = useRouter();
  const queryClient = useQueryClient();

  const form = useForm<LoginSchema>({
    resolver: zodResolver(loginSchema),
    defaultValues: { email: '', password: '' },
  });

  const { mutateAsync: signIn, isPending } = useMutation({
    mutationFn: (data: LoginSchema) => authService.signIn(data, props.type),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['session'] });
      localStorage.setItem('accessToken', res.accessToken);
      setAlertMessage({ title: 'Success', message: res.message, type: 'success' });
      router.push(props.type === 'user' ? '/' : '/company/dashboard');
    },
    onError: (error) => {
      setAlertMessage({ title: 'Error', message: error.message, type: 'error' });
    },
  });

  const onSubmit = (value: LoginSchema) => {
    signIn(value);
  };

  return (
    <div className="flex flex-col w-full gap-4">
      {alertMessage && <AlertMessage {...alertMessage} />}
      <Form {...form}>
        <form className="flex w-full flex-col gap-2" onSubmit={form.handleSubmit(onSubmit)}>
          <FormInput<LoginSchema>
            control={form.control}
            type="email"
            name="email"
            aria-label="Email"
            placeholder="user@example.com"
          />
          <FormInput<LoginSchema>
            control={form.control}
            type="password"
            name="password"
            aria-label="Password"
            placeholder="your secret password"
          />
          <Button type="submit" disabled={isPending}>
            Sign in
          </Button>
        </form>
      </Form>
    </div>
  );
}
