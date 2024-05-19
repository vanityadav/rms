import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import {
  getSession,
  isSessionActive,
  refreshToken,
  updateActiveSession,
} from "@/lib/auth";

export async function middleware(request: NextRequest) {
  const response = NextResponse.next();

  const session = await getSession(request, response);

  if (isSessionActive(request)) {
    updateActiveSession(response);
    return response;
  }

  try {
    await refreshToken(session);
  } catch (err) {
    return NextResponse.redirect(
      new URL(`/callbackUrl=${request.nextUrl.href}`, request.nextUrl.origin)
    );
  }
}

export const config = {
  matcher: ["/:path*"],
};
