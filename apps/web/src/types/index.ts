export type SessionData = {
  isAuthenticated: boolean;
  userId: number;
  username: string;
  email: string;
  role: 'JobSeeker' | 'Company';
  image: string | null;
};

export type QueryParams = {
  page: string;
  limit: string;
  keywords: string;
  location: string;
  sort: string | 'asc' | 'desc';
  classificationId: string;
  jobType: string;
};

export type ResponseSuccess = {
  success: boolean;
  message: string;
};
